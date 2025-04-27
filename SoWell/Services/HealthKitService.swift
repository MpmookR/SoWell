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
    
    //fetches steps over past 7 days
     
     func fetchStepsLast7Days(completion: @escaping ([Date: Int]) -> Void) {
         let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
         
         let calendar = Calendar.current
         let now = Date()
         guard let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) else {
             completion([:])
             return
         }
         
         var interval = DateComponents()
         interval.day = 1
         
         let query = HKStatisticsCollectionQuery(
             quantityType: stepType,
             quantitySamplePredicate: nil,
             options: .cumulativeSum,
             anchorDate: startDate,
             intervalComponents: interval
         )
         
         query.initialResultsHandler = { _, results, error in
             var stepsByDay: [Date: Int] = [:]
             
             if let statsCollection = results {
                 statsCollection.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                     let steps = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                     stepsByDay[statistics.startDate] = Int(steps)
                 }
             }
             
             DispatchQueue.main.async {
                 completion(stepsByDay)
             }
         }
         
         healthStore.execute(query)
     }
    
    // fetches sleep over past 7 days.
       func fetchSleepLast7Days(completion: @escaping ([Date: Double]) -> Void) {
           let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
           
           let calendar = Calendar.current
           let now = Date()
           guard let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) else {
               completion([:])
               return
           }
           
           let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
           
           let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
               
               var sleepByDay: [Date: Double] = [:]
               
               if let samples = samples as? [HKCategorySample] {
                   for sample in samples where sample.value == HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue {
                       let day = calendar.startOfDay(for: sample.startDate)
                       let sleepHours = sample.endDate.timeIntervalSince(sample.startDate) / 3600.0
                       sleepByDay[day, default: 0.0] += sleepHours
                   }
               }
               
               DispatchQueue.main.async {
                   completion(sleepByDay)
               }
           }
           
           healthStore.execute(query)
       }
   }

