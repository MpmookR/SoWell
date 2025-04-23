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
        VStack(alignment: .center, spacing: 15) {
            
            // Welcome Section
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
            .padding(.top, 32)
            
            // Input Fields
            VStack(spacing: 16) {
                InputField(label: "First Name", placeholder: "", systemImage: "person", text: $firstName)
                InputField(label: "Last Name", placeholder: "", systemImage: "person", text: $lastName)
                InputField(label: "Email", placeholder: "email@example.com", systemImage: "envelope", text: $email)
                InputField(label: "Password", placeholder: "••••••••", systemImage: "lock", text: $password, isSecure: true)
                InputField(label: "Confirm Password", placeholder: "••••••••", systemImage: "lock", text: $confirmPassword, isSecure: true)
            }
            .padding(.horizontal)
            .padding(.vertical, 32)
            
            // Sign Up Button
            VStack(spacing: 8) {
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
                            authVM.currentScreen = .loading // Show loading video first
                        }

                        // Delay before transitioning to home
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
                    Alert(title: Text("Error"), message: Text(authVM.errorMessage), dismissButton: .default(Text("OK")))
                }

                // OR Divider
                Text("or")
                    .font(AppFont.footnote)
                    .foregroundColor(Color.AppColor.black)
                    .frame(maxWidth: .infinity, alignment: .center)

                // Social Buttons
                HStack(spacing: 8) {
                    Button(action: {
                        // Future Apple sign-in logic
                    }) {
                        Image("apple_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(99)
                    }
                    .frame(height: 36)

                    Button(action: {
                        // Future Google sign-in logic
                    }) {
                        Image("gmail_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(99)
                    }
                    .frame(height: 36)
                }
                .padding(.horizontal, 16)
            }

            // Terms + Navigation to Login
            VStack {
                Text("By continuing, you agree to MoodApp Terms of Service and acknowledge you've read our Privacy Policy. Notice at collection.")
                    .font(AppFont.tiny)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.leading, .bottom, .trailing], 16)

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
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .background(Color.AppColor.white)
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
