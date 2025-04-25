//
//  ChartData.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
import Foundation

struct MoodDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let moodScore: Double
}

struct SleepDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let hours: Double
}

struct StepsDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}
struct GroupedMetricRecord {
    let date: Date
    let mood: Double
    let metricValue: Double
}

