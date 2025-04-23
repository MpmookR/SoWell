//
//  AuthViewModel.swift
//  SoWell

import Foundation
import SwiftUI

enum AuthScreen {
    case register, login, home
}
class AuthViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var currentScreen: AuthScreen = .login // Default to login
    
    
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
        
        let user = UserModel(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        )
        
        currentUser = user
        isAuthenticated = true
        errorMessage = ""
        print("User registered: \(user)")
        return true
    }
    
    
    func login(email: String, password: String) -> Bool {
        // Dummy login logic
        if email == "test@example.com" && password == "password" {
            currentUser = UserModel(firstName: "Test", lastName: "User", email: email, password: password)
            isAuthenticated = true
            currentScreen = .home
            return true
        } else {
            errorMessage = "Invalid credentials"
            return false
        }
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        currentScreen = .login
    }
}



