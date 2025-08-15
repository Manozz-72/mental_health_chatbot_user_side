import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_chatbot/chatgpt_services.dart';
import 'package:mental_health_chatbot/view/screens/screen_chat.dart';
import 'package:mental_health_chatbot/view/screens/screen_home.dart';

import '../../widgets/large_text.dart';
import '../../widgets/my_custom_button.dart';
import '../../widgets/small_text.dart';

class ScreenGetStarted extends StatelessWidget {
  const ScreenGetStarted({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
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
                'assets/images/login.png', // Ensure this image is in your assets folder
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 50),
              SmallText(text:"Hi! I’m your friendly chatbot, here to help you and be someone you can share your thoughts and feelings with. You can talk to me anytime, and I’ll be here to support you. You can also write down your personal notes or reflections whenever you like—it’s your safe space.",color: Colors.black,), // Add meaningful text here
              const SizedBox(height: 50),
              MyCustomButton(text:"Get Started", width: 200,loading: false, onTap: (){
                Get.to(ScreenHome() );
              }),
              const SizedBox(height: 50),// Show progress indicator
            ],
          ),
        ),
      ),
    );
  }
}
