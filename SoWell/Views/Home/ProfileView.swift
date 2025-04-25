import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authVM: AuthViewModel
    
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Custom Navigation Bar
            CustomNavBar(title: "Profile", showBackButton: true) {
                presentationMode.wrappedValue.dismiss()
            }
            
            // MARK: - Content
            VStack(spacing: 24) {
                
                VStack(spacing: 24) {
                    HStack(alignment: .top) {
                        Text("Name:")
                            .frame(width: 80, alignment: .leading)
                            .fontWeight(.bold)
                            .foregroundColor(Color.AppColor.frame)
                        Text(authVM.currentUser?.firstName ?? "Unknown")
                            .foregroundColor(Color.AppColor.frame)
                        Spacer()

                    }

                    HStack(alignment: .top) {
                        Text("Email:")
                            .frame(width: 80, alignment: .leading)
                            .fontWeight(.bold)
                            .foregroundColor(Color.AppColor.frame)

                        Text(authVM.currentUser?.email ?? "No Email")
                            .foregroundColor(Color.AppColor.frame)
                        Spacer()


                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                
                Spacer()
                // Example logout button
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        authVM.logout()
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }) {
                    PrimaryButton(label: "Log Out")
                }
                .padding(.bottom, 32)
                
            }
            .padding(.top, 24)
            .background(Color.AppColor.background)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel()) // if needed for logout logic later
}

