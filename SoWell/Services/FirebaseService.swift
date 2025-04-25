//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//
//class FirebaseService {
//    static let shared = FirebaseService() // Singleton instance
//    private let auth = Auth.auth()
//    private let db = Firestore.firestore()
//
//    private init() {}
//
//    // MARK: - Register New User
//    func registerUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        auth.createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let user = result?.user else {
//                completion(.failure(NSError(domain: "NoUser", code: -1, userInfo: nil)))
//                return
//            }
//
//            let userData: [String: Any] = [
//                "firstName": firstName,
//                "lastName": lastName,
//                "email": email
//            ]
//
//            self.db.collection("users").document(user.uid).setData(userData) { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    let newUser = UserModel(firstName: firstName, lastName: lastName, email: email, password: "")
//                    completion(.success(newUser))
//                }
//            }
//        }
//    }
//
//    // MARK: - Log In
//    func loginUser(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        auth.signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let user = result?.user else {
//                completion(.failure(NSError(domain: "NoUser", code: -1, userInfo: nil)))
//                return
//            }
//
//            self.fetchUserData(userID: user.uid) { result in
//                switch result {
//                case .success(let userData):
//                    completion(.success(userData))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//    
//    
//
//    // MARK: - Fetch User Info
//    func fetchUserData(userID: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
//        db.collection("users").document(userID).getDocument { document, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = document?.data() else {
//                completion(.failure(NSError(domain: "NoData", code: -2, userInfo: nil)))
//                return
//            }
//
//            let firstName = data["firstName"] as? String ?? ""
//            let lastName = data["lastName"] as? String ?? ""
//            let email = data["email"] as? String ?? ""
//
//            let user = UserModel(firstName: firstName, lastName: lastName, email: email, password: "")
//            completion(.success(user))
//        }
//    }
//    
//    func getCurrentUser() -> User? {
//            return Auth.auth().currentUser
//        }
//
//    // MARK: - Log Out
//    func logoutUser() throws {
//        try auth.signOut()
//    }
//    
//}
//
////Apple
//extension FirebaseService {
//    func signIn(with credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
//        Auth.auth().signIn(with: credential) { authResult, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let user = authResult?.user {
//                completion(.success(user))
//            } else {
//                completion(.failure(NSError(domain: "FirebaseSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown sign-in error."])))
//            }
//        }
//    }
//}
