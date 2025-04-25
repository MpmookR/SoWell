import SwiftUI

struct PrimaryButton: View {
    let label: String

    var body: some View {
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

struct CustomButton: View {
    var label: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(AppFont.body)
                .foregroundColor(Color.AppColor.background)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.AppColor.button)
                .cornerRadius(21)
        }
        .padding(.horizontal)
    }
}
