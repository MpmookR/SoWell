# SoWell

SoWell is an **iOS mobile health tracking app** designed to help users monitor their **mood, physical activity, and sleep patterns** in a simple, visual, and user-centred way.

Built with **SwiftUI**, **SwiftData**, and **MVVM**, the app integrates **Apple HealthKit** for real health data and **Firebase** for authentication and data persistence.

> 👩🏽‍💻 This project was developed collaboratively as part of a university coursework.
> Built collaboratively with [Kayley Govinden](https://github.com/KROSE95)

---

## 🔗 Related link
- 🌐 **[Demo & Case Study](https://mpmookr.wixsite.com/mysite/sowell)**

<p align="center">
  <img src="docs/mockup.png" width="700" alt="SoWell" /> 
</p>

## ✨ Key Features
- 🧠 **Mood Tracking** – Log daily mood with optional diary entries  
- 📔 **Diary** – Reflect on thoughts and emotions over time  
- 📅 **Calendar View** – Review mood history at a glance  
- 📊 **Health Charts** – Visualise steps and sleep data from HealthKit  
- 📈 **Weekly Mood Summary** – Identify trends and patterns  
- 🔐 **Authentication** – Secure sign-in with Firebase  

## 🛠 Tech Stack
- **Language:** Swift  
- **UI:** SwiftUI  
- **Architecture:** MVVM  
- **Persistence:** SwiftData  
- **Health Data:** Apple HealthKit  
- **Backend:** Firebase (Auth, Firestore)  

## 💡Good  to know:
**✏️ HealthKit Data (ChartViewModel)**
- If you wish to use **real HealthKit data**:
  -  Set: let useMockData = false

- If you prefer to use **mock data** for testing, set it back to:
  - let useMockData = true

