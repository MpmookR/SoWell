import SwiftUI


struct DiaryView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let mood: Mood
    @Binding var diaryText: String
    let date: Date
    @ObservedObject var viewModel: CalendarViewModel
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                CustomNavBar(title: "Diary", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                .zIndex(1)
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Date
                    Text(currentDateString())
                        .font(AppFont.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 16)
                        .padding(.horizontal, 24)
                    
                    // Mood Display
                    HStack(spacing: 16) {
                        Image(mood.imageName)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mood:")
                                .foregroundColor(.gray)
                                .font(AppFont.footnote)
                            Text(mood.label.lowercased())
                                .font(AppFont.body)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Diary Input
                    ZStack(alignment: .topLeading) {
                        // Actual TextEditor
                        TextEditor(text: $diaryText)
                            .focused($isFocused)
                            .font(AppFont.body)
                            .padding(8)
                            .frame(minHeight: 180)
                            .background(Color.white)
                            .cornerRadius(21)
                            .overlay(
                                RoundedRectangle(cornerRadius: 21)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        
                        // Placeholder text
                        if diaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text("write about your day here...")
                                .foregroundColor(.gray)
                                .font(AppFont.caption)
                                .padding(.top, 16)
                                .padding(.leading, 8)
                                .allowsHitTesting(false) //lets taps pass through to TextEditor
                        }
                    }
                    .padding(.horizontal, 24)
                    .onTapGesture {
                        isFocused = false
                    }
                    
                    Spacer()
                    
                    // Save Button
                    HStack {
                        Spacer()
                        Button(action: {
                            let trimmedText = diaryText.trimmingCharacters(in: .whitespacesAndNewlines)

                            if !trimmedText.isEmpty {
                                viewModel.trackMood(on: date, mood: mood, diary: trimmedText)
                                print("Diary saved: \(trimmedText)")
                            }

                            presentationMode.wrappedValue.dismiss()
                            hideKeyboard()
                        }) {
                            PrimaryButton(label: "save")
                        }

                        Spacer()
                    }
//                    .padding(.bottom, 90)
                    Spacer()

                    
                }
                .navigationBarTitle("Diary", displayMode: .inline)
                .background(Color.AppColor.background)
                .ignoresSafeArea(edges: .bottom)
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy"
        return formatter.string(from: Date())
    }
    
}


//#Preview {
//    DiaryView(mood: Mood.all.first { $0.label == "Not today" }!)
//}

