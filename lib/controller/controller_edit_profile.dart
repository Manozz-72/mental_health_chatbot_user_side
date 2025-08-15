// ControllerEditProfile.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../helpers/firebase_utils.dart';
import '../../helpers/db_reference.dart';

class ControllerEditProfile extends GetxController {
  RxString imagePath = "".obs; // Holds the selected image path
  TextEditingController nameController = TextEditingController(); // For username input
  RxBool showLoading = false.obs; // Loading state for UI

  /// Updates the user's profile (image and/or name)
  Future<String> updateProfile() async {
    String response = "";
    String name = nameController.text.trim();

    // Input validation: Name cannot be empty
    if (name.isEmpty) {
      return "Name cannot be empty.";
    }

    showLoading.value = true;

    try {
      String? imageUrl;

      // If a new image is selected, upload it to Firebase
      if (imagePath.value.isNotEmpty) {
        imageUrl = await FirebaseUtils.uploadImage(
          imagePath.value,
          "Users/${DbReference().uid}",
        );
      }

      // Prepare the update data
      Map<String, dynamic> updateData = {"name": name};
      if (imageUrl != null) {
        updateData["imageUrl"] = imageUrl;
      }

      // Update the Firestore document
      await DbReference().userRef.doc(FirebaseUtils.myId).update(updateData);

      // Update the Firebase Auth user details
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(name);
        if (imageUrl != null) {
          await currentUser.updatePhotoURL(imageUrl);
        }
      }

      response = "success";
    } catch (error) {
      response = error.toString();
    } finally {
      showLoading.value = false;
    }

    return response;
  }
}
