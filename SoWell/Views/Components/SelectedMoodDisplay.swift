//
//  SelectMoodDisplay.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI

struct SelectedMoodDisplay: View {
    @Binding var mood: Mood?

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center, spacing: 10) {
                Spacer()

                if let mood = mood {
                    Image(mood.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )
                }

                Spacer()
            }
            .padding(.horizontal, 75)
            .padding(.vertical, 30)
            .frame(height: 250)
            .background(
                ZStack {
                    Image("pokadot_bg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 405, height: 250)
                        .clipped()

                    if let mood = mood {
                        mood.color.opacity(0.2) 
                    } else {
                        Color.clear
                    }
                }
            )
            .cornerRadius(21)
            .frame(maxWidth: 405)

            if let mood = mood {
                Text(mood.label.lowercased())
                    .font(AppFont.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 16, maxHeight: 16)
                    .padding()
                    .background(mood.color)
                    .cornerRadius(21)
            }
        }
        .padding(.horizontal)
    }
}

