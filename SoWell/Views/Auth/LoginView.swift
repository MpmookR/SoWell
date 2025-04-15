//
//  LoginView.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            
            // Welcome Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome")
                    .font(AppFont.h1)
                    .foregroundColor(Color.AppColor.black)
                
                Text("Begin on your mindfulness journey")
                    .font(AppFont.caption)
                    .foregroundColor(Color.AppColor.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // Logo
            VStack {
                Image("sowell_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 169, height: 142)
            }
            .frame(width: 380, height: 250)
            .background(Color.AppColor.background)
            .cornerRadius(21)
            .overlay(
                RoundedRectangle(cornerRadius: 21)
                    .stroke(Color.AppColor.frame, lineWidth: 1)
            )
            .frame(maxWidth: .infinity)

            
            // Input Fields
            VStack(spacing: 20) {
                InputField(label: "Email Address", placeholder: "email123@gmail.com", systemImage: "envelope")
                InputField(label: "Password", placeholder: "password", systemImage: "lock")
                
                Text("Forgot Password?")
                    .font(.custom("SF Compact Rounded", size: 11))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // Login Button
            Button(action: {
                // login action
            }) {
                Text("Login")
                    .font(AppFont.body)
                    .foregroundColor(Color.AppColor.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.AppColor.moodBlue)
                    .cornerRadius(21)
            }
            .padding(.horizontal)
            
            // OR Divider
            Text("or")
                .font(AppFont.body)
                .foregroundColor(Color.AppColor.black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Social Buttons
            HStack(spacing: 16) {
                // Apple login
                HStack {
                    Image("AppleIcon")
                        .resizable()
                        .frame(width: 16, height: 18)
                }
                .padding(10)
                .frame(height: 36)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(99)
                
                // Google login
                HStack {
                    Image("Gmail")
                        .resizable()
                        .frame(width: 16, height: 18)
                }
                .padding(10)
                .frame(height: 36)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(99)
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 70)
        .background(Color.AppColor.white)
    }
}

#Preview {
    LoginView()
}
