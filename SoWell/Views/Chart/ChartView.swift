//
//  ChartView.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
//import SwiftUI
//import Charts
//
//struct ChartView: View {
//    @StateObject private var viewModel = ChartViewModel()
//
//    func barMarks(for moodData: [MoodDataPoint], sleepData: [SleepDataPoint], stepsData: [StepsDataPoint], comparisonType: ChartViewModel.ComparisonType) -> [AnyView] {
//        var marks: [AnyView] = []
//
//        for mood in moodData {
//            marks.append(
//                AnyView(
//                    BarMark(
//                        x: .value("Date", mood.date, unit: .day),
//                        y: .value("Mood", mood.moodScore)
//                    )
//                    .foregroundStyle(Color.purple)
//                    .position(by: .value("Metric", "Mood"))
//                )
//            )
//
//            let comparisonValue: Double
//            let label: String
//            let color: Color
//
//            switch comparisonType {
//            case .sleep:
//                comparisonValue = sleepData.first(where: { $0.date == mood.date })?.hours ?? 0
//                label = "Sleep"
//                color = .blue
//            case .steps:
//                let steps = stepsData.first(where: { $0.date == mood.date })?.steps ?? 0
//                comparisonValue = Double(steps) / 1000.0
//                label = "Steps"
//                color = .green
//            }
//
//            marks.append(
//                AnyView(
//                    BarMark(
//                        x: .value("Date", mood.date, unit: .day),
//                        y: .value(label, comparisonValue)
//                    )
//                    .foregroundStyle(color.opacity(0.6))
//                    .position(by: .value("Metric", label))
//                )
//            )
//        }
//
//        return marks
//    }
//
//    var body: some View {
//        VStack(spacing: 16) {
//            // Title
//            Text("Mood Tracker")
//                .font(.title2)
//                .bold()
//
//            // Picker for comparison type
//            Picker("Compare With", selection: $viewModel.comparisonType) {
//                ForEach(ChartViewModel.ComparisonType.allCases) { type in
//                    Text(type.rawValue).tag(type)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding(.horizontal)
//
//            // Chart
//            VStack {
//                ChartCardView(title: "Mood Tracker") {
//                    let moodData = viewModel.moodData
//                    let sleepData = viewModel.sleepData
//                    let stepsData = viewModel.stepsData
//                    let comparisonType = viewModel.comparisonType
//
//                    Chart {
//                        ForEach(Array(barMarks(for: moodData, sleepData: sleepData, stepsData: stepsData, comparisonType: comparisonType).enumerated()), id: \.offset) { _, view in
//                            view
//                        }
//                    }
//
//                    .chartYAxisLabel("Mood / Health")
//                    .frame(height: 250)
//                }
//            }
//
//        }
//        .padding()
//        .background(Color.AppColor.background)
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
//
//#Preview {
//    ChartView()
//}
