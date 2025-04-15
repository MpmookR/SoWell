//
//  CustomNavBar.swift
//  SoWell
//
//  Created by Mook Rattana on 15/04/2025.
//

import SwiftUI

struct CustomNavBar: View {
    let title: String
    let showBackButton: Bool
    let onBack: (() -> Void)?

    var body: some View {
        HStack {
            if showBackButton {
                Button(action: {
                    onBack?()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("back")
                    }
                    .font(AppFont.body)
                    .foregroundColor(Color.AppColor.button)
                }
            } else {
                // Placeholder to keep title centered
                Color.clear.frame(width: 60)
            }

            Spacer()

            Text(title)
                .font(AppFont.body)
                .foregroundColor(Color.AppColor.frame)

            Spacer()

            // Spacer to match button size on right
            Color.clear.frame(width: 60)
        }

        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 52)
        .background(Color.AppColor.background)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        .overlay(
            Rectangle()
                .inset(by: 0.5)
                .stroke(Color.AppColor.button.opacity(0.2), lineWidth: 0)
        )
    }
}
#Preview {
    CustomNavBar(title: "Test", showBackButton: true, onBack: { })
}
