//
//  CalendarView.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                CustomNavBar(title: "Calendar", showBackButton: false) {
                    presentationMode.wrappedValue.dismiss()
                }
                .zIndex(1)
                
                VStack(spacing: 16) {
                    // MARK: - Month navigation
                    HStack {
                        Button(action: { changeMonth(by: -1) }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color.AppColor.frame)
                        }
                        Spacer()
                        Text(currentMonthFormatted)
                            .font(AppFont.h2Bold)
                            .foregroundColor(Color.AppColor.frame)
                        
                        Spacer()
                        Button(action: { changeMonth(by: 1) }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.AppColor.frame)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Weekday header
                    HStack {
                        ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                            Text(day).frame(maxWidth: .infinity)
                                .font(AppFont.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // MARK: - Calendar grid
                    CalendarGridView(
                        days: generateDaysForCurrentMonth(),
                        selectedDate: selectedDate,
                        currentMonth: currentMonth,
                        entryForDate: viewModel.entry(for:),
                        onSelectDate: { date in
                            selectedDate = date
                        }
                    )
                    
                    // MARK: - Entry display
                    Divider()
                    entrySection(for: selectedDate)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .background(Color.AppColor.background)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    private var currentMonthFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private func generateDaysForCurrentMonth() -> [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
              let firstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.end) else {
            return []
        }
        
        let dates = stride(from: firstWeek.start, to: lastWeek.end, by: 60 * 60 * 24).map { $0 }
        return dates
    }
    
    @ViewBuilder
    private func entrySection(for date: Date) -> some View {
        if let entry = viewModel.entry(for: date) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Mood: \(entry.mood.label)")
                    .font(.headline)
                Text("Diary: \(entry.diaryText)")
                    .font(.body)
            }
            .padding()
        } else {
            VStack(spacing: 10) {
                Text("No mood tracked.")
                    .foregroundColor(.secondary)
                
                PrimaryButton(label: "Track Mood")
                    .onTapGesture {
                        let mockMood = Mood.all.randomElement()!
                        viewModel.trackMood(on: date, mood: mockMood, diary: "Sample diary entry.")
                    }
            }
        }
    }
}


#Preview {
    CalendarView()
}
