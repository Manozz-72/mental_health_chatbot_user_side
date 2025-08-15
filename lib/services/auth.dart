import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get the current authenticated user
  User? get currentUser => _auth.currentUser;

  // Create a CustomUser object based on Firebase User
  CustomUser? _userFromFirebaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  // Stream to listen to auth state changes (User sign in/sign out)
  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign in anonymously
  Future<CustomUser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print('Error during anonymous sign-in: ${e.toString()}');
      return null;
    }
  }

  // Sign up with email and password
  Future<CustomUser?> signUpWithEmailAndPassword(
      String fullName, String email, String password, String confirmPassword) async {
    try {
      if (password != confirmPassword) {
        throw Exception("Passwords do not match");
      }

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Add user data to Firestore
        await DatabaseService().updateUserData(
          email: email,
          name: fullName,
          isActive: true,
          age: 0, // Default age
        );

        // Save the FCM token
        await saveFCMToken(email);

        return _userFromFirebaseUser(user);
      } else {
        throw Exception("User creation failed");
      }
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<CustomUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Save the FCM token after successful login
        await saveFCMToken(email);

        return _userFromFirebaseUser(user);
      } else {
        throw Exception("User sign-in failed");
      }
    } catch (e) {
      print('Error during email sign-in: ${e.toString()}');
      return null;
    }
  }

  // Save the FCM token in Firestore
  Future<void> saveFCMToken(String email) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .set({'token': token}, SetOptions(merge: true));
        print("FCM token saved successfully.");
      } else {
        print("FCM token is null");
      }
    } catch (e) {
      print("Error saving FCM token: $e");
    }
  }

  // Login with Google
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
        await _auth.signInWithCredential(credential);

        // Save FCM token after Google login
        await saveFCMToken(userCredential.user!.email!);

        // Add/update user data in Firestore
        await DatabaseService().updateUserData(
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? "Google User",
          isActive: true,
          age: 0, // Default age
        );

        // Initialize therapy status if it's a new user
       

        return userCredential;
      } else {
        throw Exception("Google Sign-In failed");
      }
    } catch (e) {
      print('Error during Google sign-in: ${e.toString()}');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      print("User signed out successfully.");
    } catch (e) {
      print('Error during sign-out: ${e.toString()}');
    }
  }
}
