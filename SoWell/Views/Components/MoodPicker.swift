//
//  MoodPicker.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
import SwiftUI

struct MoodPicker: View {
    @Binding var selectedMood: Mood?
    
    let moods = Mood.all

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
            ForEach(moods) { mood in
                VStack(spacing: 6) {
                    Image(mood.imageName)
                        .resizable()
                        .frame(width: 46, height: 46)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(selectedMood?.id == mood.id ? Color.AppColor.frame : Color.clear, lineWidth: 2)
                        )

                    Text(mood.label)
                        .font(AppFont.footnote)
                        .foregroundColor(selectedMood?.id == mood.id ? .black : .gray)
                }
                .onTapGesture {
                    selectedMood = mood
                }
            }
        }
        .padding(.horizontal)
    }
}
