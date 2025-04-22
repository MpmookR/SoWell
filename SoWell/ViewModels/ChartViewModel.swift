//
//  ChartViewModel.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
//Handles:
//Hold the selected time range (Day, Week, etc.)
//
//Provide @Published chart data arrays
//
//Manage toggles (showSleep, showSteps)
//
//(Later) Pull real data from HealthKit
//
//Fetching mood data from SwiftData or mock source
//
//Processing + merging data into [MoodDataPoint], [SleepDataPoint], etc.
//
// Can expose @Published var moodData: [MoodDataPoint] etc. so your ChartView updates reactively.
import SwiftUI
import Combine

class ChartViewModel : ObservableObject {
    
    @Published var selectedPeriod = "Week"
    @Published var showSleep = false
    @Published var showSteps = false
    
    @Published var moodData: [MoodDataPoint] = []
    @Published var sleepData: [SleepDataPoint] = []
    @Published var stepsData: [StepsDataPoint] = []
    
    let periods = ["Day", "Week", "Month", "Year"]
    
    init() {
        loadMockData()
        //Replace loadMockData() with loadHealthKitData(for period: String)
    }
    //function will simulate 7 days of fake dara
    func loadMockData() {
        let today = Date() //gives current date and time
        moodData = (0..<7).map { offset in //loops 0 to 6 and for each day it will run the code inside each day (7 days) building an array of moodDataPoint values
            MoodDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, moodScore: Double.random(in: 1...5))
        }.reversed()
        // selects a date, adds a day on, the offset makes it a day less (-1 will = yesterday etc). Double random will provide a fake mood score.
        //.reversed() reverses it so it will start with the oldest date until today.
        
        sleepData = (0..<7).map { offset in
            SleepDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, hours: Double.random(in: 4...9))
        }.reversed()
        
        stepsData = (0..<7).map { offset in
            StepsDataPoint(date: Calendar.current.date(byAdding: .day, value: -offset, to: today)!, steps: Int.random(in: 3000...9000))
        }.reversed()
    }
    
    
    
    
}

