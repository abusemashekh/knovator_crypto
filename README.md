# flutter_task

A Flutter project using **GetX** for state management.

## Getting Started

This project is a Flutter application using Flutter SDK version 3.32.8 (or a recent compatible version).

### Prerequisites

* Flutter SDK 3.32.8 or higher
* Android Studio / VSCode
* Android Emulator or physical device
* Git

### App Setup Steps

1. **Clone the repository**

```bash
git clone https://github.com/abusemashekh/knovator_crypto.git
cd knovator_crypto
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the application**

```bash
flutter run
```

* Make sure your device/emulator is running. Confirm with:

```bash
flutter devices
```

4. **Build APK (optional)**

```bash
flutter build apk --release
```

* The generated APK will be in `build/app/outputs/flutter-apk/app-release.apk`

* **Working APK (public access):** `https://drive.google.com/file/d/1bf2ytKuMvZvF2PyG4OsGCRdKTjohXsNe/view?usp=sharing`

* **Screen Recording:** `https://drive.google.com/file/d/1CP8Aj-4bOX2KuW3qRaRCQ_v4SRFZD_YG/view?usp=sharing`

---

## Why GetX over BLoC

For this assignment, I have used **GetX** over BLoC for simplicity and speed of implementation:

* Less boilerplate compared to BLoC.
* Easy and reactive state management using `Rx` variables.
* Simple dependency injection, routing, and utility facilities.

---

## Libraries Used

* `get: ^4.7.2` — GetX for state management, routing, and dependency injection.
* `shared_preferences: ^2.5.3` — To store simple key-value data locally.
* `google_fonts: ^6.3.2` — For using custom Google Fonts in the app UI.
* `cached_network_image: ^3.4.1` — To efficiently load and cache network images.

---

## Bonus Tasks Completed ✅

I have completed the following **bonus tasks** as part of the assignment:

1. **Periodic Price Updates:** Implemented automatic price refreshing every 5 minutes using `Timer.periodic` while being mindful of API rate limits.
2. **Sorting:** Added sorting options for the portfolio list (e.g., by name, by holding value).
3. **Price Change Indication:** Implemented price change indicators — green for price increase and red for decrease — since the last refresh.
4. **Coin Logos:** Integrated fetching and displaying of cryptocurrency logos (commented out currently due to API call restrictions).
5. **Error Handling:** Added robust error handling for API requests and local storage operations to ensure better user experience.

---
