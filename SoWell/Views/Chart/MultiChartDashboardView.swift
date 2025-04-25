//
//  MultiChartDashboardView.swift
//  SoWell
//
//  Created by Kayley on 24/04/2025.
//
import SwiftUI
import Charts


struct MultiChartDashboardView: View {
    enum Period: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        
        var id: String { rawValue }
    }
    
    @State private var selectedPeriod: Period = .week
    @StateObject private var viewModel = ChartViewModel()

 

//    private var moodData: [(date: Date, score: Double)] {
//        let today = Date()
//        let calendar = Calendar.current
//        return (0..<7).map { offset in
//            (calendar.date(byAdding: .day, value: -offset, to: today)!, Double.random(in: 1...10))
//        }.reversed()
//    }
//    
//    private var moodAndStepsData: [GroupedMetricRecord] {
//        let today = Date()
//        let calendar = Calendar.current
//        return (0..<7).map { offset in
//            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
//            let mood = Double(Int.random(in: 3...10))
//            let steps = Int.random(in: 3000...10000)
//            return GroupedMetricRecord(date: date, mood: mood, metricValue: Double(steps) / 1000.0)
//        }.reversed()
//    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Mood Trend")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            Picker("Period", selection: $selectedPeriod) {
                ForEach(Period.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Chart {
                ForEach(viewModel.moodData, id: \ .date) { item in
                    BarMark(
                        x: .value("Date", item.date, unit: selectedPeriod == .year ? .month : .day),
                        y: .value("Mood", item.moodScore)
                    )
                    .foregroundStyle(Color.purple)
                }
            }
            .chartYAxisLabel("Mood Score (1–10)")
            .chartXAxis {
                AxisMarks(values: .stride(by: selectedPeriod == .year ? .month : .day, count: selectedPeriod == .month ? 5 : 1)) { value in
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            switch selectedPeriod {
                            case .week:
                                Text(date.formatted(.dateTime.weekday(.narrow))) // M, T, W
                            case .month:
                                Text(date.formatted(.dateTime.day())) // 1, 2, 3...
                            case .year:
                                Text(date.formatted(.dateTime.month(.narrow))) // J, F, M...
                            }
                        }
                    }
                }
            }
            .frame(height: 300)
            .padding(.horizontal)
            
            GroupedBarChartView(
                title: "Mood vs Steps (Past 7 Days)",
                moodLabel: "Mood",
                metricLabel: "Steps (k)",
                metricColor: .green,
                data: viewModel.moodAndStepsData
            )
            GroupedBarChartView(
                title: "Mood vs Sleep (Past 7 Days)",
                moodLabel: "Mood",
                metricLabel: "Sleep (hrs)",
                metricColor: .blue,
                data: viewModel.moodAndSleepData
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

