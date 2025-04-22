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
            ContentView()
            RegisterView()
                .environmentObject(authVM)
        }
        .modelContainer(for: MoodEntryModel.self)
    }
}
