//
//  CalendarGridView.swift
//  SoWell
//
//  Created by Mook Rattana on 15/04/2025.
//

import SwiftUI

struct CalendarGridView: View {
    let days: [Date]
    let selectedDate: Date
    let currentMonth: Date
    let entryForDate: (Date) -> MoodEntry?
    let onSelectDate: (Date) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
            ForEach(days, id: \.self) { date in
                Button {
                    onSelectDate(date)
                } label: {
                    VStack(spacing: 2) {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.caption)
                        
                        if let entry = entryForDate(date) {
                            Image(entry.mood.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .frame(width: 36, height: 48)
                    .padding(4)
                    .background(
                        Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        ? AnyView(Circle().fill(Color.AppColor.frame))
                        : AnyView(Circle().fill(Color.clear))
                    )
                    .foregroundColor(
                        Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        ? Color.AppColor.white
                        : Color.AppColor.frame
                    )
                }
                .disabled(!Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month))
            }
        }
        .padding(.horizontal)
    }
}

