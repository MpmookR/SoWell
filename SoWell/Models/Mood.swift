//
//  Mood.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
import SwiftData
import Foundation
import SwiftUICore

struct Mood: Identifiable {
    let id = UUID()
    let label: String
    let imageName: String
    let score: Int
    let color: Color
    
    static let all: [Mood] = [
        Mood(label: "Excellent", imageName: "excellent", score: 10, color: Color.AppColor.moodPink),
        Mood(label: "Happy", imageName: "happy", score: 9, color: Color.AppColor.moodPink),
        Mood(label: "Cool", imageName: "cool", score: 8, color: Color.AppColor.moodPink),
        Mood(label: "Vibe", imageName: "vibe", score: 7, color: Color.AppColor.moodPink),
        Mood(label: "Meh", imageName: "meh", score: 6, color: Color.AppColor.moodPink),
        Mood(label: "Unsure", imageName: "unsure", score: 5, color: Color.AppColor.moodBlue),
        Mood(label: "Confused", imageName: "confused", score: 4, color: Color.AppColor.moodBlue),
        Mood(label: "Not today", imageName: "nottoday", score: 3, color: Color.AppColor.moodBlue),
        Mood(label: "Sad", imageName: "sad", score: 2, color: Color.AppColor.moodPurple),
        Mood(label: "Mad", imageName: "mad", score: 1, color: Color.AppColor.moodPurple)
    ]
}


