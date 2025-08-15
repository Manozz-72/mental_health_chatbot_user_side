import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_chatbot/view/screens/screen_signup.dart';
import 'package:mental_health_chatbot/widgets/my_custom_button.dart';

class TermsAndPoliciesScreen extends StatelessWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff21AF85),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "Terms and Polices",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "1. Privacy Policy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We are committed to protecting your privacy and ensuring the security of your data.",
            ),
            const Divider(height: 30),
            const Text(
              "2. User Agreement",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "By using Mind Haven, you agree to the terms and conditions set forth in this document.",
            ),
            const Divider(height: 30),
            const Text(
              "3. Data Collection",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We collect data to improve your experience and provide mental health support.",
            ),
            const Divider(height: 30),
            const Text(
              "4. Security Measures",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We implement strict security measures to protect your data from unauthorized access.",
            ),
            const Divider(height: 30),
            const Text(
              "5. Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "If you have any questions or concerns, reach out to support@mindhaven.com.",
            ),
            const SizedBox(height: 50),

          ],
        ),
      ),
    );
  }
}
