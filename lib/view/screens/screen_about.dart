import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/large_text.dart';
import '../../widgets/medium_text.dart';
import '../../widgets/small_text.dart';

class ScreenAbout extends StatelessWidget {
  const ScreenAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDEF6FC),
      appBar: AppBar(
        backgroundColor: const Color(0xff21AF85),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "About",
          style: TextStyle(fontSize: 15),
        ),
      ),
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
          child: Column(
            children: [
              LargeText(text: "Mental Health Chatbot"),
              const SizedBox(height: 20),

              // Center-aligned description
              Center(

              ),

              const SizedBox(height: 40),
              MediumText(text: "Version", size: 15),
              const SizedBox(height: 10),
              SmallText(text: "1.0.0"),

              const SizedBox(height: 20),
              MediumText(text: "Powered by", size: 15),
              const SizedBox(height: 10),
              SmallText(text: "MindCare AI"),

              const SizedBox(height: 20),
              MediumText(text: "Connect with us", size: 15),
              const SizedBox(height: 10),
              SmallText(
                text:
                "Website: www.MindCareAI.com\nEmail: support@MindCareAI.com",
              ),
            ],
          ),
        ),
    );
  }
}
