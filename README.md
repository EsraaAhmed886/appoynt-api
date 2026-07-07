# 🏥 Appoynt — Smart Healthcare Management Ecosystem

<div align="center">

**A comprehensive digital healthcare platform connecting patients, doctors, and clinic staff**

[![Flutter](https://img.shields.io/badge/Flutter-3.22.3-blue?logo=flutter)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-Next.js-black?logo=next.js)](https://nextjs.org)
[![Dart](https://img.shields.io/badge/Dart-3.4.x-blue?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Appoynt_Team-orange)]()

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Project Goal](#-project-goal)
- [Platforms](#-platforms)
- [Key Features](#-key-features)
- [System Architecture](#-system-architecture)
- [Mobile App](#-mobile-app-flutter)
- [Web App](#-web-app-reactnextjs)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Team Members](#-team-members)

---

## 🌟 Overview

**Appoynt** is a comprehensive, smart Healthcare Management Ecosystem designed to digitize the entire patient journey. It transforms traditional clinic workflows into a seamless digital experience by connecting **patients**, **doctors**, and **clinic staff** (Receptionists & Admins) through a unified platform.

The platform consists of two main applications:

- 📱 **Mobile Application** — for patients (Flutter)
- 🌐 **Web Application** — for doctors, receptionists, and admins (React / Next.js)

---

## 🎯 Project Goal

To **eliminate clinic overcrowding**, minimize patient waiting times, and provide doctors with a centralized system for medical records and consultation management — all through a modern, intuitive digital experience.

---

## 📱🌐 Platforms

| Platform            | Technology              | Target Users  |
| ------------------- | ----------------------- | ------------- |
| Mobile App          | Flutter (iOS & Android) | Patients      |
| Doctor Dashboard    | React / Next.js         | Doctors       |
| Reception Dashboard | React / Next.js         | Receptionists |
| Admin Dashboard     | React / Next.js         | Admins        |

---

## ✨ Key Features

### 🗓 Hybrid Smart Booking

- Advanced online appointments via mobile app
- Manual walk-in bookings via clinic reception desk
- Real-time slot availability and scheduling

### ⏱ Real-time Queue Orchestration

- Dynamic engine tracking patient turns in real-time
- Live updates and estimated entry times
- Reduces physical waiting time significantly

### 📍 Geo-based Check-in

- GPS/location-aware functionality
- Automatic patient check-in upon arrival at clinic
- QR code scanning at reception

### 📁 Unified Electronic Medical Record (EMR)

- Secure, centralized patient history database
- Digital prescriptions issued by doctors
- Lab results and radiology scans storage
- Full medical history accessible anytime

### 🎥 Telemedicine Support

- Integrated video consultation features
- Remote healthcare services for patients
- Doctor-to-patient video calls

### 🔔 Smart Notifications

- Real-time queue status updates
- Appointment reminders
- Lab result availability alerts

### 🌐 Bilingual Support

- Full Arabic and English support
- RTL (Right-to-Left) layout for Arabic
- System language auto-detection on first launch

---

## 🏗 System Architecture

```
┌────────────────────────────────────────────────────────────┐
│                     APPOYNT PLATFORM                       │
├──────────────────┬─────────────────────────────────────────┤
│   MOBILE APP     │           WEB DASHBOARDS                │
│   (Flutter)      │        (React / Next.js)                │
│                  │                                         │
│  ┌────────────┐  │  ┌──────────┐ ┌──────────┐ ┌─────────┐  │
│  │  Patient   │  │  │  Doctor  │ │Reception │ │  Admin  │  │
│  │    App     │  │  │Dashboard │ │Dashboard │ │Dashboard│  │
│  └────────────┘  │  └──────────┘ └──────────┘ └─────────┘  │
└──────────────────┴────────┬────────────────────────────────┘
                            │
            ┌───────────────▼──────────────┐
            │          REST API            │
            │      (Backend Services)      │
            └───────────────┬──────────────┘
                            │
            ┌───────────────▼──────────────┐
            │          Database            │
            │   (Patient Records, EMR)     │
            └──────────────────────────────┘
```

---

## 📱 Mobile App (Flutter)

The patient-facing mobile application built with **Flutter** for both iOS and Android.

### Mobile Features

- 🔍 Search and discover doctors by specialty
- 📅 Book appointments with real-time slot selection
- 📊 Track live queue position and estimated wait time
- 📍 GPS-based automatic check-in at clinic
- 📋 View complete medical history and EMR
- 💊 Access digital prescriptions
- 🎥 Join telemedicine video consultations
- 🔔 Push notifications for updates
- 🌙 Dark / Light mode (follows system setting)
- 🌐 Arabic / English with full RTL support
- 📡 Real-time internet connectivity detection

### Authentication Flow

- Smart login — auto-detects email or phone number input
- OTP verification via SMS (6-digit numeric code)
- Password strength validation with 3-segment visual bar
- Password rules card (uppercase, lowercase, number, special char)
- Secure token storage with auto-refresh

---

## 🌐 Web App (React / Next.js)

The staff-facing web application with three separate role-based dashboards.

### Doctor Dashboard

- 📅 Manage daily and weekly schedules
- 👥 View patient queue in real-time
- 📋 Access and update patient EMR
- 💊 Issue digital prescriptions
- 🧪 Order lab tests and view results
- 🎥 Start telemedicine video consultations
- 📊 Patient history and visit notes

### Reception Dashboard

- 🚶 Register walk-in patients instantly
- 📋 Manage daily appointment list
- ⏭ Control queue flow (call next, skip, complete)
- 🔍 Search and look up patient records
- 📊 Real-time queue status overview

### Admin Dashboard

- ⚙️ Clinic configuration and settings
- 👨‍⚕️ Manage doctors and staff accounts
- 📊 Performance analytics and reports
- 📅 Working hours and holidays management
- 💰 Billing and payment overview

---

## 🛠 Tech Stack

### Mobile (Flutter)

| Category             | Package                  | Purpose                  |
| -------------------- | ------------------------ | ------------------------ |
| State Management     | `flutter_bloc`           | BLoC pattern             |
| Navigation           | `go_router`              | Routing                  |
| Networking           | `dio`                    | HTTP client              |
| Local Storage        | `flutter_secure_storage` | Secure token storage     |
| Local DB             | `hive`                   | Offline data caching     |
| Maps                 | `google_maps_flutter`    | Clinic location display  |
| Location             | `geolocator`             | GPS auto check-in        |
| Video                | `agora_rtc_engine`       | Telemedicine calls       |
| Notifications        | `firebase_messaging`     | Push notifications       |
| Dependency Injection | `get_it`                 | Service locator          |
| Connectivity         | `connectivity_plus`      | Network status detection |
| QR Code              | `mobile_scanner`         | Reception QR scanning    |
| Charts               | `fl_chart`               | Admin analytics          |
| Font                 | Inter + Cairo            | EN + AR typography       |

### Web (React / Next.js)

| Category  | Technology    | Purpose              |
| --------- | ------------- | -------------------- |
| Framework | Next.js 14    | Web application      |
| Styling   | Tailwind CSS  | UI styling           |
| State     | Redux Toolkit | State management     |
| Charts    | Recharts      | Analytics dashboards |
| Video     | Agora Web SDK | Telemedicine         |
| Auth      | NextAuth.js   | Authentication       |

### Backend (.NET & SQL Server)

| Category      | Technology                  | Purpose                 |
| ------------- | --------------------------- | ----------------------- |
| Framework     | .NET 8 / Core               | REST API Services       |
| Language      | C#                          | Server-side logic       |
| Database      | Microsoft SQL Server        | Relational data storage |
| ORM           | Entity Framework Core       | Database mapping        |
| Auth          | ASP.NET Core Identity + JWT | Security & Tokens       |
| Documentation | Swagger / OpenAPI           | API Testing & Specs     |

---

## 📁 Project Structure

### Mobile App (`appoynt_mobile_app/`)

```
README.md
```

### Web App (`appoynt_web_app/`)

```
README.md
```

### Backend (`appoynt_backend/`)

```
README.md
```

### Backend (`appoynt_testing/`)

```
README.md
```

### Backend (`appoynt_ai/`)

```
README.md
```

---

## 🚀 Getting Started

Follow these instructions to set up your local development environment.

### 📱 Mobile App Setup (Flutter)

**Prerequisites:**

- Flutter SDK 3.22.3 (Recommended via [FVM](https://fvm.app/))
- Android Studio (for Android) / Xcode (for iOS)
- [Dart](https://dart.dev/get-dart) installed globally

### 📱 Mobile App Setup (Flutter)

**Essential Prerequisites:**

1.  **JDK 17:** Required for Android compilation. [Download JDK 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html).
2.  **Android Studio:** Required for **Android SDK**, **Build-Tools**, and **Command-line Tools**.
    - _Note: Even if using VS Code, Android Studio must be installed once to initialize the toolchain._
3.  **Flutter Version Manager (FVM):** Mandatory for maintaining team-wide version consistency.

**Step-by-Step Setup:**

1.  **Install FVM Globally:**
    ```bash
    dart pub global activate fvm
    ```
2.  **Initialize Android SDK:**
    Open Android Studio -> SDK Manager -> Install **Android 14 (API 34)** and **Android SDK Command-line Tools**.
3.  **Navigate to Mobile Folder:**
    ```bash
    cd appoynt_mobile_app
    ```
4.  **Install Flutter Version:**
    ```bash
    fvm install 3.22.3
    fvm use 3.22.3
    ```
5.  **Verify Environment:**
    ```bash
    fvm flutter doctor
    ```
    _Ensure all checks pass (✅). Fix any SDK path or license issues before proceeding._
6.  **Install Dependencies:**
    ```bash
    fvm flutter pub get
    ```
7.  **Generate Code (Models/JSON):**
    ```bash
    fvm flutter pub run build_runner build --delete-conflicting-outputs
    ```
8.  **Run the Application:**
    ```bash
    fvm flutter run
    ```

---

### 🌐 Web App Setup (Next.js)

**Prerequisites:**

- [Node.js 18+](https://nodejs.org/)
- [npm](https://www.npmjs.com/) (usually comes with Node)

**Setup Steps:**

1. Navigate to directory: `cd appoynt_web_app`
2. Install dependencies: `npm install`
3. Configure environment: Create a file named `.env.local` in the `appoynt_web_app` folder:
   ```env
   NEXT_PUBLIC_API_URL=http://localhost:5000/api
   ```
4. Run development server: `npm run dev`
5. Access the app: Open [http://localhost:3000](http://localhost:3000)

---

### ⚙️ Backend Setup (.NET & MS SQL)

**Prerequisites:**

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) (Express or Developer edition)
- [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)

**Setup Steps:**

1. Navigate to directory: `cd appoynt_backend`
2. Restore NuGet packages: `dotnet restore`
3. **Database Configuration:**
   - Open `appsettings.json` in the API project.
   - Update the `DefaultConnection` string with your local SQL Server instance:
     ```json
     "ConnectionStrings": {
       "DefaultConnection": "Server=YOUR_SERVER_NAME;Database=AppoyntDB;Trusted_Connection=True;TrustServerCertificate=True;"
     }
     ```
4. **Apply Migrations:**
   - Ensure the Entity Framework tool is installed: `dotnet tool install --global dotnet-ef`
   - Run migrations to create the database: `dotnet ef database update --project Appoynt.Infrastructure --startup-project Appoynt.Api`
5. Run the API: `dotnet run --project Appoynt.Api`
6. Documentation: Once running, visit `http://localhost:5000/swagger` to see the API specs.

---

## 👥 Team Members

| #   | Name                | Role                   | Field                             |
| --- | ------------------- | ---------------------- | --------------------------------- |
| 1   | **Kareem Mangood**  | Team Lead              | Project Management & Architecture |
| 2   | **Mostafa Mahmoud** | Backend Developer      | API & Database                    |
| 3   | **Hosam Hany**      | Mobile Developer       | Flutter & Dart Development        |
| 4   | **Shimaa Salah**    | Frontend Web Developer | React / Next.js Development       |
| 5   | **Menna Ahmed**     | UI/UX Designer         | Design System & Prototyping       |
| 6   | **Habiba Ezzat**    | AI/ML Engineer         | AI & Machine Learning             |
| 7   | **Sohila Mohamed**  | AI/ML Engineer         | AI & Machine Learning             |
| 8   | **Kholoud Khaled**  | Test Engineer          | Mobile/Web Testing                |

## 🗓 Project Timeline

| Phase   | Description                | Status         |
| ------- | -------------------------- | -------------- |
| Phase 1 | Requirements & Design      | ✅ Complete    |
| Phase 2 | Mobile App — Auth Flow     | 🔄 In Progress |
| Phase 3 | Mobile App — Core Features | ⏳ Planned     |
| Phase 4 | Web Dashboards             | ⏳ Planned     |
| Phase 5 | Backend API Integration    | ⏳ Planned     |
| Phase 6 | Testing & QA               | ⏳ Planned     |
| Phase 7 | Deployment                 | ⏳ Planned     |

---

## 📄 License

This project is developed as a **Graduation Project**. All rights reserved to the Appoynt team © 2026.

---

## 📞 Contact

For any inquiries about the project:

- 📧 Email: **[mustafa.mahmoud.appoynt@gmail.com]**
- 🌐 GitHub: **[(https://github.com/kholoudkhaledAppoynt/Appoynt)]**

---

<div align="center">

**Built with ❤️ by the Appoynt Team**

_Digitizing healthcare, one appointment at a time._

</div>
