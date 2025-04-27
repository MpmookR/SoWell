import SwiftUI

struct InsightsView: View {
    let groupedInsights: [(title: String, insights: [String])]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("💡Insights")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.AppColor.background)
                .bold()
                .padding(.bottom, 4)

            ForEach(groupedInsights, id: \.title) { group in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(group.title)
                                    .font(.headline)
                                    .foregroundColor(Color.AppColor.background)
                                
                                ForEach(group.insights, id: \.self) { insight in
                                    Text("• \(insight)")
                                        .font(.body)
                                        .foregroundColor(Color.AppColor.background)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                    .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.AppColor.frame)
        )
        .padding(.horizontal)
    }
}

#Preview {
    InsightsView(groupedInsights: [
        ("Mood vs Steps", ["Your mood improves when you walk over 10k steps."]),
        ("Mood vs Sleep", ["Sleeping less than 6h links to worse mood."])
    ])
}

