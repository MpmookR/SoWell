import SwiftUI

struct ColorPreviewView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    ColorSwatch(name: "Background", color: .AppColor.background)
                    ColorSwatch(name: "Button", color: .AppColor.button)
                    ColorSwatch(name: "Frame", color: .AppColor.frame)
                    ColorSwatch(name: "White", color: .AppColor.white)
                    ColorSwatch(name: "Black", color: .AppColor.black)
                }
                
                Divider().padding(.vertical)
                
                Group {
                    ColorSwatch(name: "Mood Purple", color: .AppColor.moodPurple)
                    ColorSwatch(name: "Mood Blue", color: .AppColor.moodBlue)
                    ColorSwatch(name: "Mood Pink", color: .AppColor.moodPink)
                }
            }
            .padding()
        }
    }
}

struct ColorSwatch: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 40)
            Text(name)
                .font(.system(size: 17, weight: .medium, design: .rounded))
        }
    }
}

#Preview {
    ColorPreviewView()
}
