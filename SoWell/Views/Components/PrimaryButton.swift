//
//  PrimaryButton.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI

struct PrimaryButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 4) {
                Text(label)
                    .font(AppFont.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(width: 238, alignment: .center)
            .background(Color.AppColor.button)
            .cornerRadius(21)
        }
    }
}

