import SwiftUI
import Charts
import SwiftData

struct MultiChartDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ChartViewModel
    @StateObject private var healthKitViewModel = HealthKitViewModel()
    @Environment(\.presentationMode) private var presentationMode
    
    enum Period: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        
        var id: String { rawValue }
    }
    
    @State private var selectedPeriod: Period = .week
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: ChartViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(Color.AppColor.background) // Background color layer
                .ignoresSafeArea()
            // Scrollable content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Spacer to push down content below navbar
                    Color.clear.frame(height: 60) // assume your navbar is 60pt tall
                    
                    moodTrendSection
                    
                    InsightsView(groupedInsights: [
                        ("Mood vs Steps", viewModel.moodStepInsights),
                        ("Mood vs Sleep", viewModel.moodSleepInsights)
                    ])
                    
                    groupedChartsSection
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            
            // Sticky Navbar on top
            CustomNavBar(title: "Chart", showBackButton: false) {
                presentationMode.wrappedValue.dismiss()
            }
            .background(Color(.systemBackground)) // so it doesn't look transparent
            .zIndex(1)
        }
        .background(Color.AppColor.background)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 4) // Optional: soft shadow
        .zIndex(1) }
    
    @ViewBuilder
    private var moodTrendSection: some View {
        VStack {
            Text("Mood Trend")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            Picker("Period", selection: $selectedPeriod) {
                ForEach(Period.allCases) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Chart {
                ForEach(filteredMoodData, id: \.date) { item in
                    BarMark(
                        x: .value("Date", item.date, unit: selectedPeriod == .year ? .month : .day),
                        y: .value("Mood", item.moodScore)
                    )
                    .foregroundStyle(Color.AppColor.moodPeach)
                }
            }
            .chartYAxisLabel("Mood Score (1–10)")
            .frame(height: 300)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var groupedChartsSection: some View {
        GroupedBarChartView(
            title: "Mood vs Steps (Past 7 Days)",
            moodLabel: "Mood",
            metricLabel: "Steps (k)",
            metricColor: Color.AppColor.moodPink,
            //            data: viewModel.moodAndStepsData
            data: generateMoodAndStepsData()
        )
        
        GroupedBarChartView(
            title: "Mood vs Sleep (Past 7 Days)",
            moodLabel: "Mood",
            metricLabel: "Sleep (hrs)",
            metricColor: Color.AppColor.moodBlue,
            //            data: viewModel.moodAndSleepData
            data: generateMoodAndSleepData()
        )
    }
    
    private func generateMoodAndStepsData() -> [GroupedMetricRecord] {
        if viewModel.useMockData {
            //            return viewModel.moodAndStepsData
            //            return Array(viewModel.moodAndStepsData.prefix(7)) // Only 7 for mock
            return Array(viewModel.moodAndStepsData.sorted { $0.date > $1.date }.prefix(7)).reversed()
        } else {
            //            return viewModel.moodData.map { mood in
            //            return Array(viewModel.moodData.prefix(7)).map { mood in
            return Array(viewModel.moodData.sorted { $0.date > $1.date }.prefix(7)).reversed().map { mood in
                let day = Calendar.current.startOfDay(for: mood.date)
                let steps = Double(healthKitViewModel.stepsLast7Days[day] ?? 0) / 1000.0
                return GroupedMetricRecord(date: mood.date, mood: mood.moodScore, metricValue: steps)
            }
        }
    }
    
    private func generateMoodAndSleepData() -> [GroupedMetricRecord] {
        if viewModel.useMockData {
            //            return viewModel.moodAndSleepData
            //            return Array(viewModel.moodAndSleepData.prefix(7)) // Only 7 for mock
            return Array(viewModel.moodAndSleepData.sorted { $0.date > $1.date }.prefix(7)).reversed()
        } else {
            //            return viewModel.moodData.map { mood in
            return Array(viewModel.moodData.sorted { $0.date > $1.date }.prefix(7)).reversed().map { mood in
                let day = Calendar.current.startOfDay(for: mood.date)
                let sleep = healthKitViewModel.sleepLast7Days[day] ?? 0.0
                return GroupedMetricRecord(date: mood.date, mood: mood.moodScore, metricValue: sleep)
            }
        }
    }
    
    private var filteredMoodData: [MoodDataPoint] {
        let sortedData = viewModel.moodData.sorted { $0.date > $1.date } // Newest first
        switch selectedPeriod {
        case .week:
            return Array(sortedData.prefix(7)).reversed() // Oldest first for chart left-to-right
        case .month:
            return Array(sortedData.prefix(30)).reversed()
        case .year:
            return Array(sortedData.prefix(12)).reversed()
        }
    }
    
}

#Preview {
    do {
        let container = try ModelContainer(for: MoodEntryModel.self)
        return MultiChartDashboardView(modelContext: container.mainContext)
    } catch {
        fatalError("Failed to create preview container.")
    }
}

//---helper
extension Date {
    func isSameDay(as other: Date) -> Bool {
        let cal = Calendar.current
        return cal.isDate(self, inSameDayAs: other)
    }
}

