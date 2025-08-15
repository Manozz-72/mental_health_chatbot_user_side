import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static String? myId;

  // Upload image to Firebase Storage
  static Future<String> uploadImage(String filePath, String storagePath) async {
    File file = File(filePath);
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref(storagePath)
        .putFile(file);

    // Return the URL of the uploaded image
    return await snapshot.ref.getDownloadURL();
  }

  // Update user profile with display name and profile picture
  static Future<void> updateProfile(String displayName, File profilePicture) async {
    try {
      // Get current user from FirebaseAuth
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No user is currently logged in.");
      }

      // Upload the profile picture
      final profilePictureUrl = await uploadImage(
          profilePicture.path,
          'profile_pictures/${user.uid}.jpg'
      );

      // Update Firebase Auth profile with display name and photo URL
      await user.updateProfile(
        displayName: displayName,
        photoURL: profilePictureUrl,
      );

      // Reload user to reflect updated info
      await user.reload();

      print('Profile updated successfully');
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Error updating profile: $e');
    }
  }

  // Optional: Method to update only the display name (without changing the profile picture)
  static Future<void> updateDisplayName(String displayName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: displayName);
        await user.reload();
        print('Display name updated successfully');
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error updating display name: $e');
    }
  }
}
