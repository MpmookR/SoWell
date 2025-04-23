import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.AppColor.background
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // App logo
                Image("logo_upfrontSowell") // Replace with your actual logo asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)

                // Spinner
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.AppColor.frame))
                    .scaleEffect(1.6)

                // Message
                Text("Getting things ready...")
                    .font(AppFont.body)
                    .foregroundColor(Color.AppColor.frame)
            }
        }
    }
}
