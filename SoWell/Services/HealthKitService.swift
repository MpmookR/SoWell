//
//  HealthKitService.swift
//  SoWell
//
//  Created by  on 14/04/2025.
//
import Foundation
import HealthKit

class HealthKitService {
    static let shared = HealthKitService()
    private let healthStore = HKHealthStore()
    
    private init() {}
    
    func requestAuthorization() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        healthStore.requestAuthorization(toShare: [], read: [stepType, sleepType]) { success, error in
            if let error = error {
                print("HealthKit authorization error: \(error.localizedDescription)")
            } else {
                print("HealthKit authorization success: \(success)")
            }
        }
    }
    
    func fetchSteps(for date: Date, completion: @escaping (Int) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: date),
                                                    end: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: date)),
                                                    options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            completion(Int(sum.doubleValue(for: HKUnit.count())))
        }
        healthStore.execute(query)
    }
    
    func fetchSleep(for date: Date, completion: @escaping (Double) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: date),
                                                    end: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: date)),
                                                    options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            guard let samples = samples as? [HKCategorySample] else {
                completion(0)
                return
            }
            
            let asleepSamples = samples.filter { $0.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue }
            let totalSleep = asleepSamples.reduce(0.0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
            completion(totalSleep / 3600.0) // convert seconds to hours
        }
        
        healthStore.execute(query)
    }
}

