import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    
    @Published var currentUser: UserModel?
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var currentScreen: AuthScreen = .login // Default to login
    
    enum AuthScreen {
        case login, register, loading, home
    }
    
    init() {
        // Check if user is already authenticated with Firebase
        if let user = Auth.auth().currentUser {
            handleFirebaseLogin(user: user)
        } else {
            currentScreen = .login
        }
    }

    func handleFirebaseLogin(user: FirebaseAuth.User?) {
        guard let user = user else {
            self.errorMessage = "User not found"
            self.isAuthenticated = false
            return
        }

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstName"] as? String ?? ""
                let lastName = data?["lastName"] as? String ?? ""
                let email = user.email ?? "No Email"

                DispatchQueue.main.async {
                    self.currentUser = UserModel(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: "" // avoid storing password client-side
                    )
                    self.isAuthenticated = true
                    self.currentScreen = .home
                    self.errorMessage = ""
                    print("Firebase login success: \(email)")
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Profile data not found"
                    self.isAuthenticated = false
                }
            }
        }
    }


    func register(firstName: String, lastName: String, email: String, password: String, confirmPassword: String) -> Bool {
        // validate fields
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            return false
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                return
            }

            guard let user = result?.user else { return }
            
            // Save additional user info to Firestore
                    let db = Firestore.firestore()
                    db.collection("users").document(user.uid).setData([
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email
                    ]) { err in
                        if let err = err {
                            print("Error writing user to Firestore: \(err.localizedDescription)")
                        } else {
                            print("User saved to Firestore")
                        }
                    }

            // Store current user locally
                    DispatchQueue.main.async {
                        self?.currentUser = UserModel(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: "" // don't store raw password
                        )
                        self?.isAuthenticated = true
                        self?.currentScreen = .home
                        self?.errorMessage = ""
                    }
        }

        return true // This returns immediately. Could be changed to use async if needed.
    }

    
    
    func login(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                return
            }

            guard let user = result?.user else { return }

            DispatchQueue.main.async {
                self?.currentUser = UserModel(
                    firstName: "", // Optional: fetch from Firestore if needed
                    lastName: "",
                    email: user.email ?? "",
                    password: password
                )
                self?.isAuthenticated = true
                self?.currentScreen = .home
            }
        }

        return true
    }

    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        currentScreen = .login
    }
}



