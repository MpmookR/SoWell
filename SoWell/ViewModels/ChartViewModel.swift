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
    
    let useMockData = false // Toggle this between true (mock) or false(realdata)
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
    
    // MARK: - Insights please add this part in
    
    var moodStepInsights: [String] {
        let highStepDays = moodAndStepsData.filter { $0.metricValue > 10 } // 10k steps
        let avgMoodHighSteps = highStepDays.map { $0.mood }.average()
        let avgMoodAll = moodAndStepsData.map { $0.mood }.average()
        
        if avgMoodHighSteps > avgMoodAll {
            return ["Your mood improves on days when you walk more than 10,000 steps."]
        } else {
            return ["No strong mood boost detected from high step counts yet."]
        }
    }
    
    var moodSleepInsights: [String] {
        let lowSleepDays = moodAndSleepData.filter { $0.metricValue < 6 }
        let avgMoodLowSleep = lowSleepDays.map { $0.mood }.average()
        let avgMoodAll = moodAndSleepData.map { $0.mood }.average()
        
        if avgMoodLowSleep < avgMoodAll {
            return ["Lower sleep duration seems linked to worse mood."]
        } else {
            return ["Your sleep duration doesn't seem to affect your mood significantly."]
        }
    }
}

    // Helper extension
    private extension Array where Element == Double {
        func average() -> Double {
            guard !self.isEmpty else { return 0 }
            return self.reduce(0, +) / Double(self.count)
        }
    }
