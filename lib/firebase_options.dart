// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyCTwkVAdHdRBeB6I00jYk4HvoGHrSl02v0",
        authDomain: "mad-exam-e3b0b.firebaseapp.com",
        projectId: "mad-exam-e3b0b",
        storageBucket: "mad-exam-e3b0b.appspot.com",
        messagingSenderId: "756449054493",
        appId: "1:756449054493:web:ca2830218f32a4129a5bf4",
      );
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this platform.',
    );
  }
}