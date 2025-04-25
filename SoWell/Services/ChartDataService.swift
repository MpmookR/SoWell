//
//  ChartDataService.swift
//  SoWell
//
//  Created by Kayley on 24/04/2025.
//

import Foundation

struct ChartDataService {
    static func generateMoodAndStepsData() -> [(date: Date, mood: Double, steps: Int)] {
        let today = Date()
        let calendar = Calendar.current

        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            let mood = Double(Int.random(in: 3...9))
            let steps = Int.random(in: 3000...10000)
            return (date: date, mood: mood, steps: steps)
        }.reversed()
    }
    static func generateMoodAndSleepData() -> [(date: Date, mood: Double, sleep: Double)] {
            let today = Date()
            let calendar = Calendar.current

            return (0..<7).map { offset in
                let date = calendar.date(byAdding: .day, value: -offset, to: today)!
                let mood = Double(Int.random(in: 3...9))
                let sleep = Double.random(in: 3.0...9.0) // Sleep hours
                return (date: date, mood: mood, sleep: sleep)
            }.reversed()
        }
    }

