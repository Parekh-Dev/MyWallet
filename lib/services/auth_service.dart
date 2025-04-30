import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUpWithEmail(String email, String password, {required String name}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _createUserInFirestore(userCredential.user, name: name);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email already registered. Please log in.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      } else if (e.code == 'weak-password') {
        return 'Password is too weak.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  /// Google Sign Up: only allow if email not already registered
  Future<String?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return 'Google sign up aborted';
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Check if user already exists in Firestore
      final email = googleUser.email;
      final existing = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
      if (existing.docs.isNotEmpty) {
        return 'Email already registered. Please log in.';
      }
      // User does not exist, create user in Auth and Firestore
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await _createUserInFirestore(userCredential.user, name: googleUser.displayName);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return 'Google sign in aborted';
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Check if user exists in Firestore
      final email = googleUser.email;
      final existing = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
      if (existing.docs.isEmpty) {
        await GoogleSignIn().signOut();
        return 'Email not registered. Please sign up first.';
      }
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      await _createUserInFirestore(userCredential.user, name: googleUser.displayName);
      return null;
    } catch (e) {
      return e.toString();
    }
  }


  Future<void> _createUserInFirestore(User? user, {String? name}) async {
    if (user == null) return;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'name': name ?? user.displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
