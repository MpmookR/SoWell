import SwiftUI

struct HomepageView: View {
    let username = "Michael"
    @State private var selectedMood: Mood? = Mood.all.first { $0.label == "Excellent" }

    var body: some View {
        ZStack {
            Color.AppColor.background
                .ignoresSafeArea()
            VStack {
                
                Text(currentDateString())
                    .font(AppFont.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.horizontal, 24)
                
                Text("\(greeting()), \(username) \(greetingIcon())")
                    .font(AppFont.h2)
                    .fontWeight(.regular)
                    .padding(.horizontal, 24)
                
                Text("How are you today?")
                    .font(AppFont.body)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                
                VStack {
                    SelectedMoodDisplay(mood: $selectedMood)
                        .padding(.bottom, 24.0)
                    
                    
                    MoodPicker(selectedMood: $selectedMood)
                }
                .padding(.bottom, 16.0)
                
                PrimaryButton(label: "Confirm Mood") {
                    // Save mood or go to next screen
                }
            }
            Spacer()
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
    HomepageView()
}
