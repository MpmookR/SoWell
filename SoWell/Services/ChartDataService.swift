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

