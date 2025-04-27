SoWell is an iOS mobile health tracking app that helps users monitor their mood, physical activity, and sleep patterns.
It features mood tracking, diary entries, a calendar view, and visual charts integrating Apple HealthKit data.
Users receive weekly mood summaries, with authentication and data management handled via Firebase services.
The app is built with SwiftUI and SwiftData following the MVVM architecture, ensuring clean separation of concerns and maintainability.

📌 How to Use
1. Clone the repository.
2. Change the Bundle Identifier to KM.SoWell.

✏️ HealthKit Data (ChartViewModel)
If you wish to use real HealthKit data:

Set:
let useMockData = false

If you prefer to use mock data for testing, set it back to:
let useMockData = true

