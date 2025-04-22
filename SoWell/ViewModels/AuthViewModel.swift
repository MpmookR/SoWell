//
//  AuthViewModel.swift
//  SoWell

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false

    func register(firstName: String, lastName: String, email: String, password: String, confirmPassword: String) -> Bool {
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
}
