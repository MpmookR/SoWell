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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MoodEntryModel.self)
    }
}
