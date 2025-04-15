//
//  Utils.swift
//  SoWell
//
//  Created by Mook Rattana on 15/04/2025.
//
import SwiftUI

extension View {
    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
        #endif
    }
}

