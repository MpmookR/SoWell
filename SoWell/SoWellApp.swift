//
//  SoWellApp.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct SoWellApp: App {
    
    @StateObject private var authVM = AuthViewModel()
    
    init() {
            //Initializes Firebase when the app launches
            FirebaseApp.configure()
        }

    var body: some Scene {
        WindowGroup {
            AppEntryView()
                .environmentObject(authVM)
                .modelContainer(for: MoodEntryModel.self)
        }
    }
}
