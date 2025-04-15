import SwiftUI

//struct PrimaryButton: View {
//    let label: String
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: 8) {
//                Text(label)
//                    .font(AppFont.body)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.8)
//            }
//            .padding(.horizontal, 24)
//            .padding(.vertical, 14)
//            .frame(minHeight: 44)
//            .frame(width: 238, alignment: .center)
//            .background(Color.AppColor.button)
//            .cornerRadius(21)
//        }
//        .accessibilityLabel(Text(label))
//        .accessibilityAddTraits(.isButton)
//    }
//}

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

