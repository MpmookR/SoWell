import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

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
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        Auth.auth().signIn(with: firebaseCredential) { authResult, error in
            if let error = error {
                print("Firebase error: \(error.localizedDescription)")
            } else {
                authVM.handleFirebaseLogin(user: authResult?.user)
            }
        }
    }
}

// Custom UIViewRepresentable for ASAuthorizationAppleIDButton
struct AppleSignInButton: UIViewRepresentable {
    var onRequest: (ASAuthorizationAppleIDRequest) -> Void
    var onCompletion: (Result<ASAuthorization, Error>) -> Void
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        button.cornerRadius = 21
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate {
        let parent: AppleSignInButton
        
        init(_ parent: AppleSignInButton) {
            self.parent = parent
        }
        
        @objc func didTapButton() {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            parent.onRequest(request)
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            parent.onCompletion(.success(authorization))
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            parent.onCompletion(.failure(error))
        }
    }
}
