import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/loyalty_card_list_screen.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/loyalty_card.dart';

import 'services/notification_service.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(LoyaltyCardAdapter());
  await Hive.openBox<LoyaltyCard>('loyaltyCardBox');

  // Print FCM token for web push notification testing
  FirebaseMessaging.instance.getToken().then((token) {
    print('FCM Token: ' + (token ?? 'null'));
  });

  runApp(MyAppWithNotification());
}

class MyAppWithNotification extends StatelessWidget {
  const MyAppWithNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationService.initialize(context);
    return const MyApp();
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loyalty Card Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color(0xFF2196F3), // Soft blue
          secondary: Color(0xFF26A69A), // Teal
          background: Color(0xFFF7FAFC), // Very light gray
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Color(0xFF222222), // Almost black for text
          onSurface: Color(0xFF222222),
        ),
        scaffoldBackgroundColor: Color(0xFFF7FAFC),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF2196F3),
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFB0BEC5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
          ),
          labelStyle: TextStyle(color: Color(0xFF222222)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF26A69A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            elevation: 2,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF26A69A),
          foregroundColor: Colors.white,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Color(0xFF222222),
          displayColor: Color(0xFF222222),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/cards': (context) => const LoyaltyCardListScreen(),
      },
    );
  }
}
