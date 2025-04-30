# MAD_EXAM Flutter Project

This project will include:
- Firebase Authentication (Email/Password, Google Sign-In)
- Sign Up and Login Screens
- Modular structure for easy extension

## Setup
1. Run `flutter pub get` to install dependencies.
2. Configure Firebase for your project (Android/iOS/Web as required).
3. Update `android/app/google-services.json` and/or `ios/Runner/GoogleService-Info.plist` with your Firebase config files.
4. Run the app with `flutter run`.

## Dependencies
- firebase_core
- firebase_auth
- google_sign_in

## Structure
- /lib
  - main.dart
  - screens/
    - splash_screen.dart
---

## Overview

MAD_EXAM is a Flutter-based project designed to demonstrate Firebase Authentication (Email/Password, Google Sign-In) and a modular structure for easy extension. Users can securely sign up and log in to the app, and it serves as a starting point for further development.

---

## Key Features

- **Firebase Authentication:** Secure sign-up and login functionality using Email/Password and Google Sign-In.
- **Modular Structure:** Easy extension and modification of the project structure.
- **Sign Up and Login Screens:** User-friendly interface for registration and login.

---

## Tech Stack

- **Flutter** (cross-platform mobile framework)
- **Firebase Authentication** (secure authentication)
- **Firebase Core** (Firebase initialization)
- **Google Sign-In** (Google authentication)

---

## Getting Started

1. **Clone the Repository**
   ```sh
   git clone https://github.com/Parekh-Dev/MAD_EXAM.git
   cd MAD_EXAM
   ```
2. **Install Dependencies**
   ```sh
   flutter pub get
   ```
3. **Run the App**
   ```sh
   flutter run
   ```
4. **Firebase Setup**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective platform folders.
   - Configure Firebase in `firebase_options.dart` if needed.

---

## Project Structure

- `lib/`
  - `main.dart` – App entry point
  - `screens/`
    - `splash_screen.dart`
    - `login_screen.dart`
    - `signup_screen.dart`
    - `home_screen.dart`
  - `services/`
    - `auth_service.dart`

---

## Author & Credits

- **Name:** Dev Parekh
- **Roll No:** 22IT086
- **GitHub:** [devParekh](https://github.com/Parekh-Dev)

Special thanks to the open-source Flutter community.

---

## Extend & Contribute

- Fork the repo, create a feature branch, and submit a PR!
- Suggestions and improvements are welcome.

---

> _"You can extend this project by adding more screens and features as per your exam requirements."_