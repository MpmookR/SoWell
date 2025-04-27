import SwiftUI

struct InputField: View {
    let label: String
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    var isSecure: Bool = false
    var showToggle: Bool = false
    
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(AppFont.body)
                .foregroundColor(Color.AppColor.black)
            
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundColor(.gray.opacity(0.6))

                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(AppFont.body)
                .foregroundColor(.primary)
                .focused($isFocused)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)

                if showToggle && isSecure {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
            )
        }
    }
}
