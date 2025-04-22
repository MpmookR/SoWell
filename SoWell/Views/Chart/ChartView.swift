//
//  ChartView.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI
import Charts

struct ChartView: View {
    @StateObject private var viewModel = ChartViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            Text("Mood Tracker")
                .font(.title2)
                .bold()
            
            // Picker
            Picker("Time Range", selection: $viewModel.selectedPeriod) {
                ForEach(viewModel.periods, id: \.self) { period in
                    Text(period)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            
            // Chart
            VStack {
                ChartCardView(title: "Mood Tracker") {
                    Chart {
                        ForEach(viewModel.moodData) { mood in
                            LineMark(
                                x: .value("Date", mood.date),
                                y: .value("Mood", mood.moodScore)
                            )
                            .foregroundStyle(Color.purple)
                            .symbol(Circle())
                        }

                        if viewModel.showSleep {
                            ForEach(viewModel.sleepData) { sleep in
                                LineMark(
                                    x: .value("Date", sleep.date),
                                    y: .value("Sleep Hours", sleep.hours)
                                )
                                .foregroundStyle(Color.blue.opacity(0.5))
                            }
                        }

                        if viewModel.showSteps {
                            ForEach(viewModel.stepsData) { step in
                                LineMark(
                                    x: .value("Date", step.date),
                                    y: .value("Steps", step.steps)
                                )
                                .foregroundStyle(Color.green.opacity(0.5))
                            }
                        }
                    }
                    .chartYAxisLabel("Mood / Health")
                    .frame(height: 250)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            
            // Filter View
            ChartFilterView(showSleep: $viewModel.showSleep, showSteps: $viewModel.showSteps)
        }
        .padding()
        .background(Color.AppColor.background) // <-- this is your custom color
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ChartView()
}

