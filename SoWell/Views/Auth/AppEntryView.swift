import SwiftUI

struct AppEntryView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        ZStack {
            switch authVM.currentScreen {
            case .login:
                LoginView()
                    .transition(.move(edge: .leading))
            case .register:
                RegisterView()
                    .transition(.move(edge: .trailing))
            case .home:
                ContentView()
                    .transition(.opacity)
            case .loading:
                LoadingView()
                        .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.20), value: authVM.currentScreen)
    }
}
