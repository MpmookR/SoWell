//
//  ChartCardView.swift
//  SoWell
//
//  Created by Kayley on 22/04/2025.
//

//import Foundation
//import SwiftUI
//
//struct ChartCardView<Content: View>: View {
//    let title: String?
//    let content: Content
//
//    init(title: String? = nil, @ViewBuilder content: () -> Content) {
//        self.title = title
//        self.content = content()
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            if let title = title {
//                Text(title)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//            }
//
//            content
//                .frame(maxWidth: .infinity)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
//        .padding(.horizontal)
//    }
//}
