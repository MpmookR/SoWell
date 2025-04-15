import SwiftUI

struct InputField: View {
    let label: String
    let placeholder: String
    let systemImage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppFont.body)
                .foregroundColor(Color.AppColor.black)
            
            HStack(spacing: 20) {
                Label(placeholder, systemImage: systemImage)
                    .font(AppFont.body)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 21)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
}
