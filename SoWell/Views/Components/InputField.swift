import SwiftUI

struct InputField: View {
    let label: String
    let placeholder: String
    let systemImage: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                   Text(label)
                       .font(AppFont.body)
                       .foregroundColor(Color.AppColor.black)
                   
                   HStack(spacing: 12) {
                       Image(systemName: systemImage)
                           .foregroundColor(.gray.opacity(0.6))

                       if isSecure {
                           SecureField(placeholder, text: $text)
                               .font(AppFont.body)
                               .foregroundColor(.primary)
                       } else {
                           TextField(placeholder, text: $text)
                               .font(AppFont.body)
                               .foregroundColor(.primary)
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
