
import Foundation
import HealthKit

class HealthKitViewModel: ObservableObject {
    @Published var stepsToday: Int = 0
    @Published var sleepToday: Double = 0.0
    @Published var stepsLast7Days: [Date: Int] = [:]
    @Published var sleepLast7Days: [Date: Double] = [:]

    
    init() {
        HealthKitService.shared.requestAuthorization()
        fetchTodayData()
        fetchStepsLast7Days()
        fetchSleepLast7Days()
    }
    
//    func fetchTodayData() {
//        let today = Date()
//
//        HealthKitService.shared.fetchSteps(for: today) { [weak self] steps in
//            DispatchQueue.main.async {
//                self?.stepsToday = steps
//            }
//        }
//
//        HealthKitService.shared.fetchSleep(for: today) { [weak self] sleepHours in
//            DispatchQueue.main.async {
//                self?.sleepToday = sleepHours
//            }
//        }
//    }
    func fetchTodayData() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let steps = stepsLast7Days[today] {
            self.stepsToday = steps
        } else {
            self.stepsToday = 0
        }
        
        if let sleep = sleepLast7Days[today] {
            self.sleepToday = sleep
        } else {
            self.sleepToday = 0.0
        }
    }

    func fetchStepsLast7Days() {
        HealthKitService.shared.fetchStepsLast7Days { [weak self] stepsDict in
            DispatchQueue.main.async {
                self?.stepsLast7Days = stepsDict
                self?.fetchTodayData()
            }
        }
    }
    func fetchSleepLast7Days() {
        HealthKitService.shared.fetchSleepLast7Days { [weak self] sleepDict in
            DispatchQueue.main.async {
                self?.sleepLast7Days = sleepDict
                self?.fetchTodayData()
            }
        }
    }

}

//to implement after demo
//HealthKitService.shared.requestAuthorization { success in
//    if success {
//        self.fetchTodayData()
//    } else {
//        // maybe show error to user
//    }
//}
