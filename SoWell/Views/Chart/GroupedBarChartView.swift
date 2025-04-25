//
//  GroupedBarChartView.swift
//  SoWell
//
//  Created by Kayley on 24/04/2025.
//
import SwiftUI
import Charts

//struct GroupedMetricRecord {
//    let date: Date
//    let mood: Double
//    let metricValue: Double
//}

struct GroupedBarChartView: View {
    let title: String
    let moodLabel: String
    let metricLabel: String
    let metricColor: Color
    let data: [GroupedMetricRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title2)
                .bold()
                .padding(.horizontal)

            Chart {
                ForEach(data, id: \ .date) { record in
                    BarMark(
                        x: .value("Date", record.date, unit: .day),
                        y: .value("Value", record.mood)
                    )
                    .foregroundStyle(Color.purple)
                    .position(by: .value("Metric", moodLabel))

                    BarMark(
                        x: .value("Date", record.date, unit: .day),
                        y: .value("Value", record.metricValue)
                    )
                    .foregroundStyle(metricColor)
                    .position(by: .value("Metric", metricLabel))
                }
            }
            .chartYAxisLabel("\(moodLabel) / \(metricLabel)")
            .frame(height: 300)
            .padding(.horizontal)

            HStack(spacing: 16) {
                HStack {
                    Circle().fill(Color.purple).frame(width: 10, height: 10)
                    Text(moodLabel)
                }
                HStack {
                    Circle().fill(metricColor).frame(width: 10, height: 10)
                    Text(metricLabel)
                }
            }
            .font(.caption)
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    GroupedBarChartView(
        title: "Preview Chart",
        moodLabel: "Mood",
        metricLabel: "Steps (k)",
        metricColor: Color.green,
        data: ChartDataService.generateMoodAndStepsData().map {
            GroupedMetricRecord(date: $0.date, mood: $0.mood, metricValue: Double($0.steps) / 1000.0)
        }
    )
}
