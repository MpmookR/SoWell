import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

struct AppleButtonView: View {
    @State private var currentNonce: String?
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        AppleSignInButton(
            onRequest: { request in
                let nonce = randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(nonce)
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    handleAppleSignIn(result: authResults)
                case .failure(let error):
                    print("Apple Sign-In failed: \(error.localizedDescription)")
                }
            }
        )
        .frame(width: 360, height: 44)
    }
    
    // MARK: - Handle Apple Sign-In
    private func handleAppleSignIn(result: ASAuthorization) {
        guard
            let credential = result.credential as? ASAuthorizationAppleIDCredential,
            let nonce = currentNonce,
            let appleIDToken = credential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            print("Failed to retrieve Apple credential")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(
            providerID: AuthProviderID.apple,
            idToken: idTokenString,
            rawNonce: nonce,
            accessToken: nil
        )
        
        Auth.auth().signIn(with: firebaseCredential) { authResult, error in
            if let error = error {
                print("Firebase error: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                print("Firebase user missing after Apple Sign-In")
                return
            }
            
            // Save to Firestore if first time
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(user.uid)
            
            userRef.getDocument { document, error in
                if let document = document, document.exists {
                    print("User profile already exists.")
                    DispatchQueue.main.async {
                        authVM.handleFirebaseLogin(user: user)
                    }
                } else {
                    // First time login → Save profile
                    let fullName = credential.fullName
                    let firstName = fullName?.givenName ?? "Anonymous"
                    let lastName = fullName?.familyName ?? ""
                    let email = credential.email ?? user.email ?? ""
                    
                    userRef.setData([
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "createdAt": FieldValue.serverTimestamp()
                    ]) { err in
                        if let err = err {
                            print("Error saving Apple user profile: \(err.localizedDescription)")
                        } else {
                            print("Apple user profile saved to Firestore!")
                        }
                        
                        DispatchQueue.main.async {
                            authVM.handleFirebaseLogin(user: user)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Custom UIViewRepresentable for ASAuthorizationAppleIDButton
struct AppleSignInButton: UIViewRepresentable {
    var onRequest: (ASAuthorizationAppleIDRequest) -> Void
    var onCompletion: (Result<ASAuthorization, Error>) -> Void

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        button.cornerRadius = 21
        button.addTarget(context.coordinator, action: #selector(Coordinator.didTapButton), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        let parent: AppleSignInButton

        init(_ parent: AppleSignInButton) {
            self.parent = parent
        }

        @objc func didTapButton() {
            print("Tapped Apple Sign In button")
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            parent.onRequest(request)

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            parent.onCompletion(.success(authorization))
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            parent.onCompletion(.failure(error))
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow } ?? UIWindow()
        }
    }
}
