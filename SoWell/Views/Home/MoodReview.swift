//  MoodReview.swift
//  SoWell

import SwiftUI
import SwiftData

struct MoodReview: View {
    @Environment(\.presentationMode) var presentationMode

    let date: Date
    let initialMood: Mood?
    let isNewEntry: Bool
    @ObservedObject var viewModel: CalendarViewModel // Injected view model
    
    @State private var selectedMood: Mood? = nil
    @State private var diaryText: String = ""
    
    @State private var isAddingDiary = false
    @State private var isEditingMood = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Custom Navigation Bar
                CustomNavBar(title: "Mood", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                .zIndex(1)

                VStack(alignment: .leading, spacing: 32) {
                    // MARK: - Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(currentDateString())
                            .font(AppFont.footnote)
                            .foregroundColor(.gray)

                        Text("would you like to reflect your day?")
                            .font(AppFont.body)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                    // MARK: - Entry Section
                    EntrySectionView(
                        date: date,
                        entry: (selectedMood != nil || !diaryText.isEmpty)
                            ? MoodEntry(date: date, mood: selectedMood ?? Mood.all.first!, diaryText: diaryText)
                            : nil,
                        onTrackMood: { _ in },
                        onEdit: {
                            isEditingMood = true
                        },
                        onEditDiary: { _ in
                            isAddingDiary = true
                        }
                    )

                    Spacer()

                    // MARK: - Save Button
                    HStack {
                        Spacer()
                        Button(action: {
                            if let mood = selectedMood {
                                viewModel.trackMood(on: date, mood: mood, diary: diaryText)
                                print("Saved with mood: \(mood.label)")
                            }
                            presentationMode.wrappedValue.dismiss()

                        }) {
                            PrimaryButton(label: "save")
                        }
                        Spacer()
                    }
                    .padding(.bottom, 48)
                }
                .background(Color.AppColor.background)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $isAddingDiary) {
                if let mood = selectedMood {
                        DiaryView(
                            mood: mood,
                            diaryText: $diaryText,
                            date: date,
                            viewModel: viewModel
                        )
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                // If it's a new entry, use the mood passed from homepage
                // Otherwise, load saved mood/diary from viewModel
                if isNewEntry {
                    selectedMood = initialMood
                } else if let entry = viewModel.entry(for: date) {
                    selectedMood = entry.mood
                    diaryText = entry.diaryText
                }
            }

            // MARK: - MoodPicker Overlay
            MoodPickerOverlay(
                isPresented: $isEditingMood,
                selectedMood: $selectedMood,
                onConfirm: { mood in
                    selectedMood = mood
                }
            )

        }
    }

    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    let container = try! ModelContainer(for: MoodEntryModel.self)
    let context = container.mainContext
    let viewModel = CalendarViewModel(modelContext: context)

    return MoodReview(
        date: Date(),
        initialMood: Mood.all.first,
        isNewEntry: true,
        viewModel: viewModel
    )
    .modelContainer(container)
}
