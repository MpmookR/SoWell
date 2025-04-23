//
//  SoWellApp.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI
import SwiftData

@main
struct SoWellApp: App {
    @StateObject var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                switch authVM.currentScreen {
                case .login:
                    LoginView()
                        .environmentObject(authVM)
                        .transition(.move(edge: .leading))
                case .register:
                    RegisterView()
                        .environmentObject(authVM)
                        .transition(.move(edge: .trailing))
                case .home:
                    ContentView()
                        .environmentObject(authVM)
                        .modelContainer(for: MoodEntryModel.self)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: authVM.currentScreen)
        }
    }
}
