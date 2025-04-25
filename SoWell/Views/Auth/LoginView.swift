import SwiftUI
import AuthenticationServices    // for SignInWithAppleButton
import CryptoKit                 // for hashing the nonce
import FirebaseAuth              // for Firebase authentication

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = false

    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            
            // MARK: - Welcome Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome")
                    .font(AppFont.h1)
                    .foregroundColor(Color.AppColor.frame)

                Text("Begin on your mindfulness journey")
                    .font(AppFont.caption)
                    .foregroundColor(Color.AppColor.frame)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 32)

            // MARK: - Hero Image
            VStack {
                Image("hero_login")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 380, height: 250)
                    .clipped()
                    .cornerRadius(21)
                    .overlay(
                        RoundedRectangle(cornerRadius: 21)
                            .stroke(Color(hex: "#413B2B"), lineWidth: 2)
                    )
            }
            .frame(maxWidth: .infinity)

            // MARK: - Input Fields
            VStack {
                VStack {
                    InputField(
                        label: "Email Address",
                        placeholder: "email123@gmail.com",
                        systemImage: "envelope",
                        text: $email
                    )
                    
                    InputField(
                        label: "Password",
                        placeholder: "••••••••",
                        systemImage: "lock",
                        text: $password,
                        isSecure: true,
                        showToggle: true // Adds the eye icon
                    )
                }
                .padding(.horizontal)
                Text("Forgot Password?")
                    .font(AppFont.tiny)
                    .foregroundColor(.AppColor.button)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            

            // MARK: - Login Button & Apple Sign-In
            VStack(spacing: 12) {
                Button(action: {
                    let success = authVM.login(email: email, password: password)
                    if success {
                        withAnimation {
                            authVM.currentScreen = .loading
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                authVM.currentScreen = .home
                            }
                        }
                    }
                }) {
                    Text("Log In")
                        .font(AppFont.body)
                        .foregroundColor(Color.AppColor.background)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.AppColor.button)
                        .cornerRadius(21)
                }
                .padding(.horizontal)

                Text("or")
                    .font(AppFont.footnote)
                    .foregroundColor(.gray)

                AppleButtonView()
                    .environmentObject(authVM)
                    .padding(.horizontal)
            }

            // MARK: - Footer
            VStack(spacing: 12) {
                Text("By continuing, you agree to SoWell's Terms of Service and acknowledge you've read our Privacy Policy.")
                    .font(AppFont.tiny)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                HStack(spacing: 4) {
                    Text("Not on SoWell yet?")
                        .font(AppFont.tiny)
                        .foregroundColor(.gray)

                    Text("Sign up")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color.AppColor.frame)
                        .onTapGesture {
                            withAnimation {
                                authVM.currentScreen = .register
                            }
                        }
                }
            }
            .padding(.bottom)

            Spacer()
        }
        .background(Color.AppColor.white)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
