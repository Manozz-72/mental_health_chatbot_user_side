import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For showing toast messages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_health_chatbot/view/screens/screen_login.dart';

import '../../widgets/medium_text.dart';
import '../../widgets/my_custom_button.dart';
import '../../widgets/my_input_field3.dart';
import 'Screen_splash.dart'; // For Firebase Authentication

class ScreenForget extends StatefulWidget {
  const ScreenForget({super.key});

  @override
  State<ScreenForget> createState() => _ScreenForgetState();
}

class _ScreenForgetState extends State<ScreenForget> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  // Regular expression for validating email
  bool _isValidEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  // Function to handle password reset process
  Future<void> _handlePasswordReset() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter an email address.");
      return;
    }

    // Validate email format
    if (!_isValidEmail(email)) {
      Fluttertoast.showToast(msg: "Please enter a valid email.");
      return;
    }

    try {
      // Send password reset email
      await _auth.sendPasswordResetEmail(email: email);

      // Show a success message
      Fluttertoast.showToast(msg: "Password reset link sent! Please check your email.");

      // Redirect to a confirmation screen or back to the login screen
      Get.to(ScreenLogin());

    } catch (e) {
      Fluttertoast.showToast(msg: "Error sending password reset email: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff21AF85),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text("Forget Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Image.asset("assets/images/login.png"),
              const SizedBox(height: 15),
              MediumText(text: "Please enter your email \n to reset the password"),
              const SizedBox(height: 50),
              MyInputField3(
                hint: "Email",
                controller: _emailController,
                obscureText: false, initialValue: '', // Not obscuring the email input
              ),
              const SizedBox(height: 50),
              MyCustomButton(
                text: "Reset Password",
                width: 200,
                loading: false,
                onTap: _handlePasswordReset,
                margin: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
