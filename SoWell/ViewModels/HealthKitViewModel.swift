//
//  HealthKitViewModel.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
import Foundation

class HealthKitViewModel: ObservableObject {
    @Published var stepsToday: Int = 0
    @Published var sleepToday: Double = 0.0
    
    init() {
        HealthKitService.shared.requestAuthorization()
        fetchTodayData()
    }
    
    func fetchTodayData() {
        let today = Date()
        
        HealthKitService.shared.fetchSteps(for: today) { [weak self] steps in
            DispatchQueue.main.async {
                self?.stepsToday = steps
            }
        }
        
        HealthKitService.shared.fetchSleep(for: today) { [weak self] sleepHours in
            DispatchQueue.main.async {
                self?.sleepToday = sleepHours
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

