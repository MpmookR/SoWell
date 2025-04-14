//
//  TabButton.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//
import SwiftUI

struct TabButton: View {
    let icon: Image
    let label: String
    let isSelected: Bool
    let action: () -> Void
    let sizeMultiplier: CGFloat // New parameter to control size
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                icon
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(
                        width: 24 * sizeMultiplier, // Scale width
                        height: 24 * sizeMultiplier // Scale height
                    )
                
                if !label.isEmpty {
                    Text(label)
                        .font(AppFont.footnote) // Using your custom font
                        .fontWeight(.medium) // Optional: Add if you want medium weight
                        .scaleEffect(sizeMultiplier) // Scale the text proportionally
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .foregroundColor(isSelected ? Color.AppColor.frame : Color.AppColor.button)
    }
}
