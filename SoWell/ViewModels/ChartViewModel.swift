//
//  ChartViewModel.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
import SwiftUI
import Combine

class ChartViewModel: ObservableObject {
    enum ComparisonType: String, CaseIterable, Identifiable {
        case sleep = "Sleep"
        case steps = "Steps"
        
        var id: String { rawValue }
    }
    
    @Published var comparisonType: ComparisonType = .sleep
    @Published var selectedPeriod = "Week"
    
    @Published var moodData: [MoodDataPoint] = []
    @Published var sleepData: [SleepDataPoint] = []
    @Published var stepsData: [StepsDataPoint] = []
    
    let periods = ["Day", "Week", "Month", "Year"]
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        let today = Date()
        moodData = (0..<7).map { offset in
            MoodDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, moodScore: Double.random(in: 1...5))
        }.reversed()
        
        stepsData = (0..<7).map { offset in
            StepsDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, steps: Int.random(in: 3000...9000))
        }.reversed()
        
        sleepData = (0..<7).map { offset in
            SleepDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, hours: Double.random(in: 4...9))
        }.reversed()
    }
    var moodAndStepsData: [GroupedMetricRecord] {
           ChartDataService.generateMoodAndStepsData().map {
               GroupedMetricRecord(date: $0.date, mood: $0.mood, metricValue: Double($0.steps) / 1000.0)
           }
       }

       var moodAndSleepData: [GroupedMetricRecord] {
           ChartDataService.generateMoodAndSleepData().map {
               GroupedMetricRecord(date: $0.date, mood: $0.mood, metricValue: $0.sleep)
           }
       }
   }



