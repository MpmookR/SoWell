//
//  ChartDataService.swift
//  SoWell
//
//  Created by Kayley on 24/04/2025.
//

//import Foundation

//struct ChartDataService {
//    static func generateMoodAndStepsData() -> [(date: Date, mood: Double, steps: Int)] {
//        let today = Date()
//        let calendar = Calendar.current
//
//        return (0..<7).map { offset in
//            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
//            let mood = Double(Int.random(in: 3...9))
//            let steps = Int.random(in: 3000...10000)
//            return (date: date, mood: mood, steps: steps)
//        }.reversed()
//    }
//    static func generateMoodAndSleepData() -> [(date: Date, mood: Double, sleep: Double)] {
//            let today = Date()
//            let calendar = Calendar.current
//
//            return (0..<7).map { offset in
//                let date = calendar.date(byAdding: .day, value: -offset, to: today)!
//                let mood = Double(Int.random(in: 3...9))
//                let sleep = Double.random(in: 3.0...9.0) // Sleep hours
//                return (date: date, mood: mood, sleep: sleep)
//            }.reversed()
//        }
//    }

import Foundation

struct ChartDataService {
    
    static func generateMoodData(for period: String) -> [MoodDataPoint] {
        generateData(for: period) { date in
            MoodDataPoint(date: date, moodScore: Double.random(in: 1...10))
        }
    }
    
    static func generateStepsData(for period: String) -> [StepsDataPoint] {
        generateData(for: period) { date in
            StepsDataPoint(date: date, steps: Int.random(in: 3000...10000))
        }
    }
    
    static func generateSleepData(for period: String) -> [SleepDataPoint] {
        generateData(for: period) { date in
            SleepDataPoint(date: date, hours: Double.random(in: 4...9))
        }
    }
    
    // MARK: - Private Helper
    private static func generateData<T>(for period: String, create: (Date) -> T) -> [T] {
        let today = Date()
        let calendar = Calendar.current
        let range: Int
        
        switch period.lowercased() {
        case "day":
            range = 1
        case "week":
            range = 7
        case "month":
            range = 30
        case "year":
            range = 365
        default:
            range = 7
        }
        
        return (0..<range).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            return create(date)
        }.reversed() // so the newest dates are last
    }
}
