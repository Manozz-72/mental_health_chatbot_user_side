import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_chatbot/view/screens/screen_login.dart';
import 'package:mental_health_chatbot/view/screens/screen_signup.dart';
import 'package:mental_health_chatbot/widgets/small_text.dart';

import '../../widgets/large_text.dart';
import '../../widgets/my_custom_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScreenSplash(),
    );
  }
}

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Soft calming gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB2DFDB), // Soft teal
              Color(0xFFE0F7FA), // Very light aqua
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 10),
              LargeText(
                text: "AI - Mental Health Chatbot",
                color: Colors.black, // Deep teal for trust
              ),
              const SizedBox(height: 50),
              SmallText(
                text: "AI-powered mental health chatbot offering support and guidance.",
                color: Colors.black,
              ),
              const SizedBox(height: 50),
              MyCustomButton(
                text: "Login",
                onTap: () {
                  Get.to(ScreenLogin());
                },
                loading: false,
              ),
              const SizedBox(height: 10),
              MyCustomButton(
                text: "Create Account",
                loading: false,
                onTap: () {
                  Get.to(ScreenSignup());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
