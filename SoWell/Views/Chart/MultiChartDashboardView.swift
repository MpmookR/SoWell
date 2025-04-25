//
//  MultiChartDashboardView.swift
//  SoWell
//
//  Created by Kayley on 24/04/2025.
//
import SwiftUI
import Charts



struct MultiChartDashboardView: View {
    private var moodData: [(date: Date, score: Double)] {
        let today = Date()
        let calendar = Calendar.current
        return (0..<7).map { offset in
            (calendar.date(byAdding: .day, value: -offset, to: today)!, Double.random(in: 1...10))
        }.reversed()
    }
    
    private var moodAndStepsData: [GroupedMetricRecord] {
        let today = Date()
        let calendar = Calendar.current
        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            let mood = Double(Int.random(in: 3...10))
            let steps = Int.random(in: 3000...10000)
            return GroupedMetricRecord(date: date, mood: mood, metricValue: Double(steps) / 1000.0)
        }.reversed()
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Mood Trend")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            Chart {
                ForEach(moodData, id: \ .date) { item in
                    BarMark(
                        x: .value("Date", item.date, unit: .day),
                        y: .value("Mood", item.score)
                    )
                    .foregroundStyle(Color.purple)
                }
            }
            .chartYAxisLabel("Mood Score (1–10)")
            .frame(height: 300)
            .padding(.horizontal)
            
            GroupedBarChartView(
                title: "Mood vs Steps (Past 7 Days)",
                moodLabel: "Mood",
                metricLabel: "Steps (k)",
                metricColor: Color.green,
                data: moodAndStepsData
            )
        }
    }
}
    #Preview {
        MultiChartDashboardView()
    }
    
    //---helper
    extension Date {
        func isSameDay(as other: Date) -> Bool {
            let cal = Calendar.current
            return cal.isDate(self, inSameDayAs: other)
        }
    }

