# Flutter Realtime Bidding App

A production-ready Flutter project built using **TDD architecture**, **Firebase**, **offline capabilities**, and **modern state management**.

---

## 🚀 Key Features

* **Realtime Bidding System**

  * Supports **two user types**
  * Bids update in **realtime** using Firebase
  * Secure and scalable data flow
* **Firebase Integration**

  * Authentication
  * Firestore database
  * Cloud Functions (if used)
  * Realtime updates
* **Offline Functionality**

  * Powered by **Hive** for local storage
  * App continues functioning without internet
  * Syncs data automatically when online
* **TDD Architecture**

  * Unit tests, widget tests, and integration tests
  * Clean folder structure following test-driven development
* **State Management**

  * **BLoC** for complex logic
  * **Provider** for lightweight dependency injection


## 🛠️ How to Run the Project

Follow these steps to set up and run the app locally.

### 1. **Clone the repository**

```bash
git clone <repo-url>
cd <project-folder>
```

### 2. **Install Flutter dependencies**

```bash
flutter pub get
```

### 3. **Set up Firebase**

Make sure Firebase is correctly configured.

#### Android

Place the `google-services.json` file in:

```
android/app/google-services.json
```

#### iOS

Place the `GoogleService-Info.plist` in:

```
ios/Runner/GoogleService-Info.plist
```

#### Web

Firebase config should be inside:

```
web/index.html
```


### 4. **Initialize Hive**

Hive boxes are opened on app start. No extra setup required except ensuring the device has storage permission if needed.

---

### 5. **Run the application**

```bash
flutter run
```

To run on specific platforms:

```bash
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

---

## 🧪 Running Tests (TDD Enabled)

Run all tests:

```bash
flutter test
```

Run a specific test file:

```bash
flutter test test/<file_name>.dart
```

---
