import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false

    var body: some View {
        VStack {
            // MARK: - Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Create Account")
                    .font(AppFont.h1)
                    .foregroundColor(Color.AppColor.frame)

                Text("Let’s get started with your mindfulness journey")
                    .font(AppFont.caption)
                    .foregroundColor(Color.AppColor.frame)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.vertical, 8)

            // MARK: - Input Fields
            VStack {
                InputField(label: "First Name", placeholder: "", systemImage: "person", text: $firstName)
                InputField(label: "Last Name", placeholder: "", systemImage: "person", text: $lastName)
                InputField(label: "Email", placeholder: "email@example.com", systemImage: "envelope", text: $email)
                
                // Password fields with toggle
                InputField(label: "Password", placeholder: "••••••••", systemImage: "lock", text: $password, isSecure: true, showToggle: true)
                InputField(label: "Confirm Password", placeholder: "••••••••", systemImage: "lock", text: $confirmPassword, isSecure: true, showToggle: true)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            // MARK: - Sign Up + Apple Sign-In
            VStack(spacing: 12) {
                Button(action: {
                    let success = authVM.register(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        confirmPassword: confirmPassword
                    )
                    if success {
                        withAnimation {
                            authVM.currentScreen = .loading
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                authVM.currentScreen = .home
                            }
                        }
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("Sign Up")
                        .font(AppFont.body)
                        .foregroundColor(Color.AppColor.background)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.AppColor.button)
                        .cornerRadius(21)
                }
                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(authVM.errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }

                Text("or")
                    .font(AppFont.footnote)
                    .foregroundColor(.gray)

                AppleButtonView()
                    .environmentObject(authVM)
                    .padding(.horizontal)
            }
            .padding(.vertical, 16)

            // MARK: - Footer / Terms / Navigation
            VStack(spacing: 12) {
                Text("By continuing, you agree to SoWell's Terms of Service and acknowledge you've read our Privacy Policy.")
                    .font(AppFont.tiny)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(AppFont.tiny)
                        .foregroundColor(.gray)

                    Text("Log In")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color.AppColor.frame)
                        .onTapGesture {
                            withAnimation {
                                authVM.currentScreen = .login
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
    RegisterView()
        .environmentObject(AuthViewModel())
}
