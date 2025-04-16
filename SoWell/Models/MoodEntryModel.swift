//
//  MoodEntryModel.swift
//  SoWell
//
//  Created by Mook Rattana on 16/04/2025.
//

import Foundation
import SwiftData

@Model
class MoodEntryModel {
    var id: UUID
    var date: Date
    var moodLabel: String
    var imageName: String
    var diaryText: String

    init(date: Date, moodLabel: String, imageName: String, diaryText: String) {
        self.id = UUID()
        self.date = date
        self.moodLabel = moodLabel
        self.imageName = imageName
        self.diaryText = diaryText
    }
}
