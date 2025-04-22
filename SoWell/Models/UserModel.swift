//
//  UserModel.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
import Foundation

struct UserModel: Identifiable, Codable {
    var id: UUID = UUID()  // Use var so Swift can override it when decoding
    var firstName: String
    var lastName: String
    var email: String
    var password: String
}

