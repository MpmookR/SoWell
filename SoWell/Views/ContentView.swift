import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var calendarViewModel: CalendarViewModel
    @State private var diaryText: String = ""
    
    init() {
            // Use a dummy context just to satisfy @StateObject
            let dummyContainer = try! ModelContainer(for: MoodEntryModel.self)
            _calendarViewModel = StateObject(wrappedValue: CalendarViewModel(modelContext: dummyContainer.mainContext))
        }
    
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
                            CalendarView(
                                viewModel: calendarViewModel
                            )
                        }
                    case 1:
                        NavigationStack {
                            HomepageView(viewModel: calendarViewModel)
                        }
                    case 2:
                        NavigationStack {
                            GroupedBarChartView(
                                title: "Mood vs Steps",
                                moodLabel: "Mood",
                                metricLabel: "Steps (k)",
                                metricColor: Color.green,
                                data: ChartDataService.generateMoodAndStepsData().map {
                                    GroupedMetricRecord(
                                        date: $0.date,
                                        mood: $0.mood,
                                        metricValue: Double($0.steps) / 1000.0
                                    )
                                }
                            )


                        }
                    default:
                        NavigationStack {
                            HomepageView(viewModel: calendarViewModel)
                        }
                    }
                }
                
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
            
            // Inject real context from SwiftData after modelContext is ready
            .onAppear {
                calendarViewModel.loadFromStorage() // This assumes modelContext is already correct
            }
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: MoodEntryModel.self)
}



