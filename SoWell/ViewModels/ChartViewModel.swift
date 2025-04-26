//
//  ChartViewModel.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
//import SwiftUI
//import Combine
////moodentry holds the mood data.calling date and mood.
//class ChartViewModel: ObservableObject {
//    enum ComparisonType: String, CaseIterable, Identifiable {
//        case sleep = "Sleep"
//        case steps = "Steps"
//
//        var id: String { rawValue }
//    }
//
//    @Published var comparisonType: ComparisonType = .sleep
//    @Published var selectedPeriod = "Week"
//
//    @Published var moodData: [MoodDataPoint] = []
//    @Published var sleepData: [SleepDataPoint] = []
//    @Published var stepsData: [StepsDataPoint] = []
//
//    let periods = ["Day", "Week", "Month", "Year"]
//
//    init() {
//        loadMockData()
//    }
//
//    func loadMockData() {
//        let today = Date()
//        moodData = (0..<7).map { offset in
//            MoodDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, moodScore: Double.random(in: 1...5))
//        }.reversed()
//
//        stepsData = (0..<7).map { offset in
//            StepsDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, steps: Int.random(in: 3000...9000))
//        }.reversed()
//
//        sleepData = (0..<7).map { offset in
//            SleepDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, hours: Double.random(in: 4...9))
//        }.reversed()
//    }
//    var moodAndStepsData: [GroupedMetricRecord] {
//           ChartDataService.generateMoodAndStepsData().map {
//               GroupedMetricRecord(date: $0.date, mood: $0.mood, metricValue: Double($0.steps) / 1000.0)
//           }
//       }
//
//       var moodAndSleepData: [GroupedMetricRecord] {
//           ChartDataService.generateMoodAndSleepData().map {
//               GroupedMetricRecord(date: $0.date, mood: $0.mood, metricValue: $0.sleep)
//           }
//       }
//   }

import SwiftUI
import Combine
import SwiftData

class ChartViewModel: ObservableObject {
//    @Environment(\.modelContext) private var modelContext
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
    
    let useMockData = true // Toggle this between true or false
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
            self.modelContext = modelContext
            
            if useMockData {
                loadMockData()
            } else {
                fetchRealData()
            }
        }
    
    
    func loadMockData() {
        moodData = ChartDataService.generateMoodData(for: selectedPeriod)
        stepsData = ChartDataService.generateStepsData(for: selectedPeriod)
        sleepData = ChartDataService.generateSleepData(for: selectedPeriod)
    }
    
    func fetchRealData() {
        do {
            let moodEntryModels = try modelContext.fetch(FetchDescriptor<MoodEntryModel>())
            
            moodData = moodEntryModels.map { entry in
                MoodDataPoint(date: entry.date, moodScore: moodScore(for: entry.moodLabel))
            }
            
            // sleepData and stepsData will come from HealthKit separately
            
        } catch {
            print("Error fetching mood entries: \(error)")
        }
    }

    
    func moodScore(for label: String) -> Double {
        return Double(Mood.all.first(where: { $0.label.lowercased() == label.lowercased() })?.score ?? 5)
    }
    // Switching moodAndStepsData for moodData and stepsData arrays
    var moodAndStepsData: [GroupedMetricRecord] {
        moodData.map { mood in
            let matchingSteps = stepsData.first(where: { $0.date.isSameDay(as: mood.date) })?.steps ?? 0
            return GroupedMetricRecord(date: mood.date, mood: mood.moodScore, metricValue: Double(matchingSteps) / 1000.0)
        }
    }
    
    var moodAndSleepData: [GroupedMetricRecord] {
        moodData.map { mood in
            let matchingSleep = sleepData.first(where: { $0.date.isSameDay(as: mood.date) })?.hours ?? 0.0
            return GroupedMetricRecord(date: mood.date, mood: mood.moodScore, metricValue: matchingSleep)
        }
    }
    
}



