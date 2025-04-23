//
//  LoginView.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = false
    @State private var navigateToHome = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            // Welcome Section
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
            
            
            // Logo
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
            
            
            // Input Fields
            VStack(spacing: 16) {
                InputField(label: "Email Address", placeholder: "email123@gmail.com", systemImage: "envelope", text: $email)
                
                InputField(label: "Password", placeholder: "password", systemImage: "lock", text: $password, isSecure: true)
                
                Text("Forgot Password?")
                    .font(AppFont.tiny)
                    .foregroundColor(.AppColor.button)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 32)
            
            // Login Button
            VStack(spacing: 8) {
                // Hidden navigation trigger
                Button(action: {
                        // Simulate a successful login
                        let success = authVM.login(email: email, password: password)
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
                
                // OR Divider
                Text("or")
                    .font(AppFont.footnote)
                    .foregroundColor(Color.AppColor.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Social Buttons
                HStack(spacing: 8) {
                    // Apple login
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
                    
                    // Google login
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
            
            VStack {
                VStack {
                    Text("By continuing, you agree to MoodApp Terms of Service and acknowledge you've read our Privacy Policy. Notice at collection.")
                        .font(AppFont.tiny)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.leading, .bottom, .trailing], 16)
                
                
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
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                
            }
            Spacer()
        }
        .background(Color.AppColor.white)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel()) // This avoids crashes
}

