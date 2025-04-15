//
//  MoodReview.swift
//  SoWell
//
//  Created by Mook Rattana on 15/04/2025.
//

import SwiftUI

struct MoodReview: View {
    // Allows this view to dismiss itself (e.g., go back) when using a custom nav bar
    @Environment(\.presentationMode) var presentationMode
    @State private var isAddingDiary = false
    @State private var isEditingMood = false
    @State var selectedMood: Mood?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavBar(title: "Mood", showBackButton: true) {
                    presentationMode.wrappedValue.dismiss()
                }
                .zIndex(1) // Bring it above background and allow shadow
                
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Date + Heading
                    VStack(alignment: .leading, spacing: 8) {
                        Text(currentDateString())
                            .font(AppFont.footnote)
                            .foregroundColor(.gray)
                        
                        Text("would you like to reflect your day?")
                            .font(AppFont.body)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    // Diary Row
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(hex: "#F5F5F5"))
                            .frame(width: 48, height: 48)
                            .overlay(
                                Text("✍️")
                                    .font(.system(size: 24))
                            )
                        
                        Text("Diary")
                            .font(AppFont.body)
                        
                        Spacer()
                        
                        Button(action: {
                            isAddingDiary = true
                        }) {
                            Text("add")
                                .font(AppFont.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.15))
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Mood Row
                    if let mood = selectedMood{
                        
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
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingMood = true
                            }) {
                                Text("edit")
                                    .font(AppFont.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue.opacity(0.15))
                                    .cornerRadius(30)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                        
                        // Save Button
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // Save action logic here
                                if let mood = selectedMood {
                                    print("Saved with mood: \(mood.label)")
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    print("No mood selected.")
                                }
                            }) {
                                PrimaryButton(label: "save")
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom, 48)
                        
                    }
                }
                .background(Color.AppColor.background)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $isAddingDiary) {
                if let mood = selectedMood {
                    DiaryView(mood: mood)
                } else {
                    EmptyView()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            
            // MoodPicker overlay
            if isEditingMood {
                ZStack {
                    // Dim background behind the picker
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isEditingMood = false // dismiss on tap outside
                        }
                        .zIndex(2) // Ensure it's above everything else
                    
                    // Bottom sheet
                    VStack(spacing: 0) {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            // Mood picker content
                            Text("Select Mood")
                                .font(AppFont.body)
                                .padding(.vertical, 24.0)
                            
                            MoodPicker(selectedMood: $selectedMood)
                                .padding(.horizontal)
                            Spacer()
                            
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 380)
                        .background(Color.white)
//                        .cornerRadius(21)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isEditingMood)
                    }
                    .zIndex(3) // Highest zIndex to ensure it's on top
                    .ignoresSafeArea(edges: .bottom)
                }
                // Add this to ensure the ZStack covers the entire screen including tab bar
                    .ignoresSafeArea(edges: [.bottom, .top])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy"
        return formatter.string(from: Date())
    }
}

#Preview {
    MoodReview(selectedMood: Mood(label: "Happy", imageName: "happy", score: 9, color: Color.AppColor.moodPink))
}

