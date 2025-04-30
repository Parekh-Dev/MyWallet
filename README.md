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
    - login_screen.dart
    - signup_screen.dart
    - home_screen.dart
  - services/
    - auth_service.dart

---

You can extend this project by adding more screens and features as per your exam requirements.
22IT086
devParekh