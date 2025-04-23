//
//  RegisterView.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var navigateToSuccess = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text("Create account")
                        .font(
                            Font.custom("SF Compact Rounded", size: 24)
                                .weight(.semibold)
                        )
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Subtitle
                    //                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ")
                    //                        .font(Font.custom("SF Compact Rounded", size: 17))
                    //                        .foregroundColor(.black)
                    //                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    // Input Fields
                    VStack(alignment: .leading, spacing: 16) {
                        InputField(label: "First Name", placeholder: "", systemImage: "person.fill", text: $firstName)
                        InputField(label: "Last Name", placeholder: "", systemImage: "person.fill", text: $lastName)
                        InputField(label: "Email", placeholder: "", systemImage: "envelope.fill", text: $email)
                        InputField(label: "Password", placeholder: "", systemImage: "lock.fill", text: $password, isSecure: true)
                        InputField(label: "Confirm Password", placeholder: "", systemImage: "lock.fill", text: $confirmPassword, isSecure: true)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    // Sign Up Button
                    CustomButton(label: "Sign Up") {
                        let success = authVM.register(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword
                        )
                        if success {
                            withAnimation {
                                authVM.currentScreen = .home
                            }
                        } else {
                            showAlert = true
                        }
                    }
                    
                    // OR Divider
                    Text("or")
                        .font(AppFont.body)
                        .foregroundColor(Color.AppColor.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Social Buttons
                    HStack(spacing: 16) {
                        HStack {
                            Image("AppleIcon")
                                .resizable()
                                .frame(width: 16, height: 18)
                        }
                        .padding(10)
                        .frame(height: 36)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(99)
                        .frame(maxWidth: .infinity)
                        
                        HStack {
                            Image("Gmail")
                                .resizable()
                                .frame(width: 16, height: 18)
                        }
                        .padding(10)
                        .frame(height: 36)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(99)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 16)
                    
                    // Terms
                    Text("By continuing, you agree to MoodApp Terms of Service and acknowledge you've read our Privacy Policy. Notice at collection.")
                        .font(AppFont.tiny)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.AppColor.black)
                        .padding(.horizontal)
                        .frame(width: 350, alignment: .top)
                    
                    // Navigation to login
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(AppFont.tiny)
                            .foregroundColor(.AppColor.black)
                        
                        Text("Log In")
                            .font(AppFont.tiny)
                            .lineLimit(0)
                            .fontWeight(.bold )
                            .foregroundColor(.blue)
                            .onTapGesture {
                                withAnimation {
                                    authVM.currentScreen = .login
                                }
                            }

                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                .padding(.top, 40)
                .padding(.bottom, 70)
            }
            .background(Color.AppColor.white)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(authVM.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $navigateToSuccess) {
                Text("Welcome, \(firstName)! 🎉")
            }
        }
    }
}

#Preview {
    
    RegisterView()
        .environmentObject(AuthViewModel()) // //make sure the preview injects the //view model too!
}
