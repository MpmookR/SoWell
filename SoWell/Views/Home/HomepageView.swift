import SwiftUI
import SwiftData
import FirebaseAuth

struct HomepageView: View {
    //    let username = "Michael"
    @EnvironmentObject var authVM: AuthViewModel
    @ObservedObject var viewModel: CalendarViewModel
    @StateObject private var healthKitViewModel = HealthKitViewModel()
    @State private var selectedMood: Mood? = Mood.all.first { $0.label == "Excellent" }
    @State private var currentMood: Mood = Mood.all.first!
    @State private var trackingDate: Date = Date()
    
    var body: some View {
        ZStack {
            Color.AppColor.background
                .ignoresSafeArea()
            VStack {
                HStack {
                    ZStack {
                        Text(currentDateString())
                            .font(AppFont.footnote)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    NavigationLink(destination: ProfileView()) {
                        Circle()
                            .fill(Color.AppColor.button)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color.AppColor.white)
                                    .font(.system(size: 14, weight: .bold))
                            )
                    }
                }
                .padding(.horizontal, 24)
                
                HStack {
                    (
                        Text("\(greeting()), ") +
                        Text(authVM.currentUser?.firstName ?? "Unknown").font(AppFont.h2Bold) +
                        Text(" \(greetingIcon())")
                    )
                    .font(AppFont.h2)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
                
                
                Text("How are you today?")
                    .font(AppFont.body)
                    .padding(.vertical, 16)
                
                VStack {
                    SelectedMoodDisplay(mood: $selectedMood)
                        .padding(.bottom, 24.0)
                    
                    
                    MoodPicker(selectedMood: $selectedMood)
                }
                .padding(.bottom, 16.0)
                
                //Passing date, seleted mood to MoodReview page
                NavigationLink(
                    destination: MoodReview(
                        date: Date(),
                        initialMood: selectedMood,
                        isNewEntry: true,
                        viewModel: viewModel
                    )
                ) {
                    PrimaryButton(label: "Track Mood")
                }
                
                .onTapGesture {
                    trackingDate = Date() // lock the date when user taps
                }
                //  Testing healthkit retrieval steps and sleep
                // VStack(spacing: 12) {
                //                        Text("Steps Today: \(healthKitViewModel.stepsToday)")
                //                        .font(.headline)
                //                                .foregroundColor(.purple)
                //                    Text(String(format: "Sleep Today: %.1f hours",healthKitViewModel.sleepToday))
                //                        .font(.headline)
                //                                .foregroundColor(.blue)
                //    
                
                Spacer()
                
            }
        }
    }
    
    //logic
    private func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
    
    // Choose emoji by hour
    private func greetingIcon() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "☀️"
        case 12..<17:
            return "🌟"
        default:
            return "🌛"
        }
    }
    
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy"
        return formatter.string(from: Date())
    }
}



#Preview {
    let container = try! ModelContainer(for: MoodEntryModel.self)
    let context = container.mainContext
    let viewModel = CalendarViewModel(modelContext: context)
    
    return HomepageView(viewModel: viewModel)
        .modelContainer(container)
}




