import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    
    let tabBarHeight: CGFloat = 90 // Adjust height as needed
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Main content area
                //custom tabview will need the NavigationStack to wrap each view
                ZStack {
                    switch selectedTab {
                    case 0:
                        NavigationStack {
                            CalendarView()
                        }
                    case 1:
                        NavigationStack {
                            HomepageView()
                        }
                    case 2:
                        NavigationStack {
                            ChartView()
                        }
                    default:
                        NavigationStack {
                            HomepageView()
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                // Custom tab bar
                HStack(spacing: 0) {
                    // Calendar tab (normal size)
                    TabButton(
                        icon: Image(systemName: "calendar"),
                        label: "Calendar",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 },
                        sizeMultiplier: 1.0
                    )
                    
                    // Home tab
                    TabButton(
                        icon: Image("logo").resizable(),
                        label: "",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 },
                        sizeMultiplier: 2.5 // 2.5x bigger
                    )
                    
                    // Chart tab (normal size)
                    TabButton(
                        icon: Image(systemName: "chart.bar.fill"),
                        label: "Chart",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 },
                        sizeMultiplier: 1.0 
                    )
                }
                .frame(height: tabBarHeight)
                .background(Color(red: 0.95, green: 0.91, blue: 0.80))
                .accentColor(Color.AppColor.frame)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    ContentView()
}

