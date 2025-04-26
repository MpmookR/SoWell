//
//  MultiChartDashboardView.swift
//  SoWell
//
//  Created by Kayley on 24/04/2025.
//
//import SwiftUI
//import Charts
//
//
//struct MultiChartDashboardView: View {
//    @Environment(\.modelContext) private var modelContext
//    @StateObject private var viewModel: ChartViewModel
//    
//    enum Period: String, CaseIterable, Identifiable {
//        case week = "Week"
//        case month = "Month"
//        case year = "Year"
//        
//        var id: String { rawValue }
//    }
//    
//    @State private var selectedPeriod: Period = .week
//    
//            init() {
//            _viewModel = StateObject(wrappedValue: ChartViewModel(modelContext: modelContext))
//        }
//    
//    
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            
//                VStack(spacing: 24) {
//                    VStack {
//                        Text("Mood Trend")
//                            .font(.title2)
//                            .bold()
//                            .padding(.horizontal)
//                        
//                        Picker("Period", selection: $selectedPeriod) {
//                            ForEach(Period.allCases) { period in
//                                Text(period.rawValue).tag(period)
//                            }
//                        }
//                        .pickerStyle(.segmented)
//                        .padding(.horizontal)
//                        
//                        
//                        Chart {
//                            ForEach(viewModel?.moodData ?? [], id: \.date) { item in
//                                BarMark(
//                                    x: .value("Date", item.date, unit: selectedPeriod == .year ? .month : .day),
//                                    y: .value("Mood", item.moodScore)
//                                )
//                                .foregroundStyle(Color.purple)
//                            }
//                        }
//                        .chartYAxisLabel("Mood Score (1–10)")
//                        .chartXAxis {
//                            AxisMarks(values: .stride(by: selectedPeriod == .year ? .month : .day, count: selectedPeriod == .month ? 5 : 1)) { value in
//                                AxisValueLabel {
//                                    if let date = value.as(Date.self) {
//                                        switch selectedPeriod {
//                                        case .week:
//                                            Text(date.formatted(.dateTime.weekday(.narrow))) // M, T, W
//                                        case .month:
//                                            Text(date.formatted(.dateTime.day())) // 1, 2, 3...
//                                        case .year:
//                                            Text(date.formatted(.dateTime.month(.narrow))) // J, F, M...
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        .frame(height: 300)
//                        .padding(.horizontal)
//                    }
//                    
//                    GroupedBarChartView(
//                        title: "Mood vs Steps (Past 7 Days)",
//                        moodLabel: "Mood",
//                        metricLabel: "Steps (k)",
//                        metricColor: .green,
//                        data: viewModel.moodAndStepsData
//                    )
//                    GroupedBarChartView(
//                        title: "Mood vs Sleep (Past 7 Days)",
//                        moodLabel: "Mood",
//                        metricLabel: "Sleep (hrs)",
//                        metricColor: .blue,
//                        data: viewModel.moodAndSleepData
//                    )
//                    
//                }.padding(.bottom, 32)
//                    .frame(minHeight: UIScreen.main.bounds.height)
//            }
//        }
//        }
//    
//#Preview {
//    MultiChartDashboardView()
//}
//    
//    //---helper
//    extension Date {
//        func isSameDay(as other: Date) -> Bool {
//            let cal = Calendar.current
//            return cal.isDate(self, inSameDayAs: other)
//        }
//    }
import SwiftUI
import Charts
import SwiftData

struct MultiChartDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ChartViewModel

    enum Period: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case year = "Year"

        var id: String { rawValue }
    }

    @State private var selectedPeriod: Period = .week

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ChartViewModel(modelContext: modelContext))
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                moodTrendSection
                groupedChartsSection
            }
            .padding(.bottom, 32)
            .frame(minHeight: UIScreen.main.bounds.height)
        }
    }

    @ViewBuilder
    private var moodTrendSection: some View {
        VStack {
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
                ForEach(viewModel.moodData, id: \.date) { item in
                    BarMark(
                        x: .value("Date", item.date, unit: selectedPeriod == .year ? .month : .day),
                        y: .value("Mood", item.moodScore)
                    )
                    .foregroundStyle(Color.purple)
                }
            }
            .chartYAxisLabel("Mood Score (1–10)")
            .frame(height: 300)
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var groupedChartsSection: some View {
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

#Preview {
    do {
        let container = try ModelContainer(for: MoodEntryModel.self)
        return MultiChartDashboardView(modelContext: container.mainContext)
    } catch {
        fatalError("Failed to create preview container.")
    }
}

    //---helper
    extension Date {
        func isSameDay(as other: Date) -> Bool {
            let cal = Calendar.current
            return cal.isDate(self, inSameDayAs: other)
        }
    }

