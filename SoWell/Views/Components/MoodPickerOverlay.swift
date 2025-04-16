//
//  MoodPickerOverlay.swift
//  SoWell
//
//  Created by Mook Rattana on 16/04/2025.
//

import SwiftUI

struct MoodPickerOverlay: View {
    @Binding var isPresented: Bool
    @Binding var selectedMood: Mood?
    var onConfirm: ((Mood) -> Void)? = nil
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
                    .zIndex(2)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("Mood")
                            .font(AppFont.body)
                            .padding(.top, 24)
                        
                        MoodPicker(selectedMood: $selectedMood)
                            .padding(.horizontal)
                        
                        Spacer()
                        // Select button
                        Button(action: {
                            if let mood = selectedMood {
                                onConfirm?(mood) 
                            }
                            isPresented = false
                        }) {
                            Text("Select")
                                .font(AppFont.body)
                                .frame(minWidth: 250, minHeight: 18)
                                .padding()
                                .background(Color.AppColor.button)
                                .foregroundColor(.white)
                                .cornerRadius(21)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 380)
                    .background(Color.white)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: isPresented)
                }
                .zIndex(3)
                .ignoresSafeArea(edges: .bottom)
            }
            .ignoresSafeArea(edges: [.bottom, .top])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
