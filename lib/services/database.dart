import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Initialize new user with therapy status and FCM token
  Future<void> initializeUserData(String email, String name, int age) async {
    try {
      DocumentSnapshot userDoc = await usersCollection.doc(email).get();

      if (!userDoc.exists) {
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        Map<String, dynamic> userData = {
          'name': name,
          'email': email,
          'age': age,
          'isActive': true,
          'token': fcmToken,

        };

        await usersCollection.doc(email).set(userData);

      }
    } catch (e) {
      print("Error initializing user: $e");
      throw Exception("Failed to initialize user.");
    }
  }

  // Update user data
  Future<void> updateUserData({
    required String email,
    required String name,
    required int age,
    required bool isActive,
    String? fcmToken,
  }) async {
    try {
      DocumentSnapshot userDoc = await usersCollection.doc(email).get();
      Map<String, dynamic>? existingData = userDoc.data() as Map<String, dynamic>?;

      Map<String, dynamic> userData = {
        'name': name,
        'email': email,
        'age': age,
        'isActive': isActive,
      };

      if (fcmToken != null) {
        userData['token'] = fcmToken;
      }

      if (existingData?['monitoring'] != null) {
        userData['monitoring'] = existingData!['monitoring'];
      }

      await usersCollection.doc(email).set(userData, SetOptions(merge: true));
      print("User data updated successfully.");
    } catch (e) {
      print("Error updating user data: $e");
      throw Exception("Failed to update user data.");
    }
  }


  // Add a notification
  Future<void> addNotification(String email, String title, String message) async {
    try {
      await usersCollection.doc(email).collection('notifications').add({
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      throw Exception("Failed to add notification.");
    }
  }

  // Send welcome notification
  Future<void> sendWelcomeNotification(String userEmail) async {
    try {
      await usersCollection
          .doc(userEmail)
          .collection('notifications')
          .add({
        'title': 'Welcome to Autism Connect!',
        'message': 'Thank you for signing up. We are glad to have you!',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending welcome notification: $e");
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print("Password reset email sent.");
    } catch (e) {
      print("Error sending password reset email: $e");
      throw Exception("Failed to send password reset email.");
    }
  }

  // Save FCM Token
  Future<void> saveFCMToken(String email) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await usersCollection.doc(email).set({'token': fcmToken}, SetOptions(merge: true));
        print("FCM Token saved successfully.");
      }
    } catch (e) {
      print("Error saving FCM token: $e");
      throw Exception("Failed to save FCM token.");
    }
  }

  // Get FCM Token
  Future<String?> getFCMToken(String email) async {
    try {
      DocumentSnapshot snapshot = await usersCollection.doc(email).get();
      return snapshot.exists ? snapshot['token'] as String? : null;
    } catch (e) {
      print("Error retrieving FCM token: $e");
      return null;
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String email) async {
    try {
      DocumentSnapshot userDoc = await usersCollection.doc(email).get();
      return userDoc.exists ? userDoc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      print("Error fetching user data: $e");
      throw Exception("Failed to fetch user data.");
    }
  }

  // Save chatbot message
  Future<void> saveMessage(String email, String role, String content) async {
    try {
      await usersCollection.doc(email).collection('messages').add({
        'role': role,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving message: $e');
      throw Exception('Failed to save message');
    }
  }

  // Load conversation history
  Future<List<Map<String, String>>> loadConversation(String email) async {
    try {
      final snapshot = await usersCollection
          .doc(email)
          .collection('messages')
          .orderBy('timestamp')
          .get();

      return snapshot.docs.map((doc) => {
        'role': doc['role'] as String,
        'content': doc['content'] as String,
      }).toList();
    } catch (e) {
      print('Error loading conversation: $e');
      return [];
    }
  }

  // Detect dominant mood
  Future<String?> detectDominantMood(String email) async {
    final messages = await loadConversation(email);
    final userMessages = messages.where((m) => m['role'] == 'user');

    int anxious = 0, sad = 0, happy = 0;

    for (var msg in userMessages) {
      final text = msg['content']!.toLowerCase();
      if (text.contains("anxious") || text.contains("worried")) anxious++;
      if (text.contains("sad") || text.contains("depressed")) sad++;
      if (text.contains("happy") || text.contains("good")) happy++;
    }

    if (anxious > sad && anxious > happy) return "anxious";
    if (sad > anxious && sad > happy) return "sad";
    if (happy > anxious && happy > sad) return "happy";
    return null;
  }

  // Debug: Print chat history
  Future<void> debugPrintConversation(String email) async {
    final history = await loadConversation(email);
    for (final msg in history) {
      print("[${msg['role']}] ${msg['content']}");
    }
  }

}
