//
//  MoodEntry.swift
//  SoWell
//
//  Created by Mook Rattana on 15/04/2025.
//

import Foundation

struct MoodEntry: Identifiable {
    let id = UUID()
    let date: Date
    let mood: Mood
    let diaryText: String
}
