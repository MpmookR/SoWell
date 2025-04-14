//
//  LoginView.swift
//  SoWell
//
//  Created by Mook Rattana on 14/04/2025.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: - Reusable Input Field View
    func inputField(label: String, placeholder: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("SF Pro", size: 17))
                .foregroundColor(.black)
            
            HStack(spacing: 20) {
                Label(placeholder, systemImage: systemImage)
                    .font(.custom("SF Pro", size: 17))
                    .foregroundColor(Color(white: 0.85))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(white: 0.99))
            .overlay(
                RoundedRectangle(cornerRadius: 21)
                    .stroke(Color(white: 0.85), lineWidth: 1)
            )
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            
            // Welcome Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome")
                    .font(.custom("SF Compact Rounded", size: 24).weight(.semibold))
                    .foregroundColor(.black)
                
                Text("Begin on your mindfulness journey.")
                    .font(.custom("SF Compact Rounded", size: 17))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // Logo
            ZStack {
                Image("sowell_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 169, height: 142)
            }
            .frame(width: 408, height: 250)
            .background(Color(red: 1, green: 0.99, blue: 0.96))
            .cornerRadius(21)
            .overlay(
                RoundedRectangle(cornerRadius: 21)
                    .stroke(Color(red: 0.25, green: 0.23, blue: 0.17), lineWidth: 1)
            )
            
            // Input Fields
            VStack(spacing: 20) {
                inputField(label: "Email Address", placeholder: "email123@gmail.com", systemImage: "envelope")
                inputField(label: "Password", placeholder: "password", systemImage: "lock")
                
                Text("Forgot Password?")
                    .font(.custom("SF Compact Rounded", size: 11))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // Login Button
            Button(action: {
                // your login logic here
            }) {
                Text("Login")
                    .font(.custom("SF Pro", size: 17))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.85, green: 0.93, blue: 1.0))
                    .cornerRadius(21)
            }
            .padding(.horizontal)
            
            // OR Divider
            Text("or")
                .font(.custom("SF Compact Rounded", size: 17))
                .foregroundColor(.black)
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
                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                .cornerRadius(99)
                
                // Hello login
                HStack {
                    Image("Gmail")
                        .resizable()
                        .frame(width: 16, height: 18)
                }
                .padding(10)
                .frame(height: 36)
                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                .cornerRadius(99)
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 70)
        .background(Color.white)
    }
}

#Preview {
    LoginView()
}

#Preview {
    LoginView()
}
