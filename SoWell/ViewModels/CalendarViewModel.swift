//
//  CalendarViewModel.swift
//  SoWell
//
//  Created by Mook Rattana on 15/04/2025.
//

import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var entries: [Date: MoodEntry] = [:]
    
    
    //hardcorded to test
    init() {
            preloadTestEntries()
        }

        private func preloadTestEntries() {
            let today = Calendar.current.startOfDay(for: Date())
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
            let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

            entries[today] = MoodEntry(date: today, mood: Mood.all[1], diaryText: "Felt good today!")
            entries[yesterday] = MoodEntry(date: yesterday, mood: Mood.all[2], diaryText: "Was a chill day.")
            entries[twoDaysAgo] = MoodEntry(date: twoDaysAgo, mood: Mood.all[4], diaryText: "Meh, could’ve been better.")
        }

    /// Normalize to start of day to avoid time mismatches
    private func normalized(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    /// Check if there's an entry for a specific date
    func entry(for date: Date) -> MoodEntry? {
        entries[normalized(date)]
    }

    /// Add or update a mood entry
    func trackMood(on date: Date, mood: Mood, diary: String) {
        let day = normalized(date)
        let entry = MoodEntry(date: day, mood: mood, diaryText: diary)
        entries[day] = entry
    }

    /// For UI: check if a date is tracked
    func isDateTracked(_ date: Date) -> Bool {
        entries.keys.contains(normalized(date))
    }

    /// For calendar display: get all tracked days in current month
    func trackedDates(for month: Date) -> [Date] {
        entries.keys.filter { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }
    }
}
