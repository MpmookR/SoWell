import SwiftUI
import SwiftData

struct CalendarView: View {
    // MARK: - State & ViewModel
    @ObservedObject var viewModel: CalendarViewModel
        
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    @State private var diaryText: String = ""
    @State private var isEditingMood = false
    @State private var selectedMood: Mood? = nil
    @State private var isAddingDiary = false
    @State private var isAddingNewMood = false

    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // MARK: - Main Calendar Layout
            VStack(spacing: 0) {
                // Custom nav bar with back button
                CustomNavBar(title: "Calendar", showBackButton: false) {
                    presentationMode.wrappedValue.dismiss()
                }
                .zIndex(1)
                
                VStack(spacing: 16) {
                    // MARK: - Month Navigation
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
                    
                    // MARK: - Weekday Headers
                    HStack {
                        ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(AppFont.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // MARK: - Calendar Grid View
                    CalendarGridView(
                        days: generateDaysForCurrentMonth(),
                        selectedDate: selectedDate,
                        currentMonth: currentMonth,
                        entryForDate: viewModel.entry(for:),
                        onSelectDate: { date in
                            selectedDate = date
                        }
                    )
                    
                    // MARK: - Entry Detail Section
                    Divider()
                    VStack {
                        EntrySectionView(
                            date: selectedDate,
                            entry: viewModel.entry(for: selectedDate),
                            onTrackMood: { date in
                                selectedDate = date
                                isAddingNewMood = true
                            },
                            onEdit: {
                                // Preload selected mood and open overlay
                                isEditingMood = true
                                selectedMood = viewModel.entry(for: selectedDate)?.mood
                            },
                            onEditDiary: { date in
                                isAddingDiary = true
                                selectedMood = viewModel.entry(for: selectedDate)?.mood
                                diaryText = viewModel.entry(for: selectedDate)?.diaryText ?? ""
                            }
                        )
                    }
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .background(Color.AppColor.background)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            
            // for diary editing
            .navigationDestination(isPresented: $isAddingDiary) {
                if let mood = selectedMood {
                        DiaryView(
                            mood: mood,
                            diaryText: $diaryText,
                            date: selectedDate,
                            viewModel: viewModel
                        )
                } else {
                    EmptyView()
                }
            }
            
            // for mood tracking
            .navigationDestination(isPresented: $isAddingNewMood) {
                MoodReview(
                    date: selectedDate,
                    initialMood: Mood.all.first,
                    isNewEntry: true,
                    viewModel: viewModel
                )
            }

            
            // MARK: - Mood Picker Overlay (Bottom Sheet)
            MoodPickerOverlay(
                isPresented: $isEditingMood,
                selectedMood: $selectedMood,
                onConfirm: { mood in
                    // Update view model when mood is selected
                    let currentDiary = viewModel.entry(for: selectedDate)?.diaryText ?? ""
                    viewModel.trackMood(on: selectedDate, mood: mood, diary: currentDiary)
                }
            )
        }
    }
    
    // MARK: - Helpers
    
    private func changeMonth(by value: Int) {
        // Adjust the current month forward or backward
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
        // Generate all visible days for the current month including leading/trailing days
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentMonth),
              let firstWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: monthInterval.end) else {
            return []
        }
        
        let dates = stride(from: firstWeek.start, to: lastWeek.end, by: 60 * 60 * 24).map { $0 }
        return dates
    }
}





