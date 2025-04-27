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

    func register(firstName: String, lastName: String, email: String, password: String, confirmPassword: String) {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        if password.count < 6 {
            errorMessage = "Password must be at least 6 characters long."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Registration failed: \(error.localizedDescription)"
                }
                return
            }
            
            guard let user = result?.user else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to create user."
                }
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "firstName": firstName,
                "lastName": lastName,
                "email": email
            ]) { err in
                if let err = err {
                    print("Error saving profile: \(err.localizedDescription)")
                } else {
                    print("User profile saved to Firestore")
                }
            }
            
            DispatchQueue.main.async {
                self?.currentUser = UserModel(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: ""
                )
                self?.isAuthenticated = true
                self?.currentScreen = .home
                self?.errorMessage = ""
            }
        }
    }

    
    
    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            isAuthenticated = false
            return
        }

        DispatchQueue.main.async {
            self.currentScreen = .loading
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Login failed: \(error.localizedDescription)"
                    self?.isAuthenticated = false
                    self?.currentScreen = .login
                }
                return
            }

            guard let user = result?.user else {
                DispatchQueue.main.async {
                    self?.errorMessage = "User not found."
                    self?.isAuthenticated = false
                    self?.currentScreen = .login
                }
                return
            }

            // ✅ Fetch user profile from Firestore
            self?.handleFirebaseLogin(user: user)
        }
    }

    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        currentScreen = .login
    }
}
