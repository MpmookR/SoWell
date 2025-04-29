import Foundation
import SwiftUI
import SwiftData

//cloud sync
//import FirebaseFirestore
//import FirebaseAuth


class CalendarViewModel: ObservableObject {
    @Published var entries: [Date: MoodEntry] = [:]
    
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
            self.modelContext = modelContext
            loadFromStorage()
        }
    
    func updateContextIfNeeded(_ context: ModelContext) {
        if modelContext !== context {
            self.modelContext = context
            loadFromStorage()
        }
    }

    // Normalize to start of day to avoid time mismatches
    private func normalized(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    //Check if there's an entry for a specific date
    func entry(for date: Date) -> MoodEntry? {
        entries[normalized(date)]
    }

    //Add or update a mood entry
    func trackMood(on date: Date, mood: Mood, diary: String) {
           let day = normalized(date)
           
           let descriptor = FetchDescriptor<MoodEntryModel>(
               predicate: #Predicate { $0.date == day }
           )
           
           do {
               if let existing = try modelContext.fetch(descriptor).first {
                   existing.moodLabel = mood.label
                   existing.imageName = mood.imageName
                   existing.diaryText = diary
               } else {
                   let entry = MoodEntryModel(
                       date: day,
                       moodLabel: mood.label,
                       imageName: mood.imageName,
                       diaryText: diary
                   )
                   modelContext.insert(entry)
               }
               
               // Save to in-memory for UI
               entries[day] = MoodEntry(date: day, mood: mood, diaryText: diary)
               
               // NEW: Save to Firestore as cloud backup
//               FirebaseMoodService.uploadMood(date: day, mood: mood, diary: diary)

           } catch {
               print("Error saving mood entry: \(error)")
           }
       }

    func loadFromStorage() {
            do {
                let descriptor = FetchDescriptor<MoodEntryModel>()
                let stored = try modelContext.fetch(descriptor)
                print("Loaded \(stored.count) stored mood entries")

                for item in stored {
                    let day = normalized(item.date)
                    if let mood = Mood.all.first(where: { $0.label == item.moodLabel }) {
                        entries[day] = MoodEntry(date: day, mood: mood, diaryText: item.diaryText)
                    } else {
                        print("No mood matched \(item.moodLabel)")
                    }
                }
            } catch {
                print("Error loading from storage: \(error)")
            }
        }




    /// For UI: check if a date is tracked
    func isDateTracked(_ date: Date) -> Bool {
        entries.keys.contains(normalized(date))
    }

    /// For calendar display: get all tracked days in current month
    func trackedDates(for month: Date) -> [Date] {
        entries.keys.filter { Calendar.current.isDate($0, equalTo: month, toGranularity: .month) }
    }
    

}
