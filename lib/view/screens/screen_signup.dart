import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_chatbot/view/screens/screen_get_started.dart';
import 'package:mental_health_chatbot/view/screens/screen_login.dart';
import 'package:mental_health_chatbot/view/screens/screen_terms_policies.dart';
import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../../widgets/large_text.dart';
import '../../widgets/my_custom_button.dart';
import '../../widgets/my_input_field3.dart';
import '../../widgets/my_input_field4.dart';
import '../../widgets/small_text.dart';
import 'Screen_splash.dart';

class ScreenSignup extends StatelessWidget {
  final isChecked = false.obs;
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final loading = false.obs;

  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  ScreenSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => loading.value
        ? const Loading()
        : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff21AF85),
        centerTitle: true,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LargeText(text: "Create your Account",color: Colors.black,),
                  const SizedBox(height: 50),
                  MyInputField3(
                    hint: "Full Name",
                    validator: (val) => val!.length < 3
                        ? 'Full Name must be at least 3 characters'
                        : null,
                    onChange: (val) {
                      fullName = val!;
                    },
                    obscureText: false,
                    initialValue: '',
                  ),
                  const SizedBox(height: 10),
                  MyInputField3(
                    hint: "Email",
                    validator: (val) =>
                    val!.isEmpty ? 'Enter an email' : null,
                    onChange: (val) {
                      email = val!;
                    },
                    obscureText: false,
                    initialValue: '',
                  ),
                  const SizedBox(height: 10),
                  Obx(
                        () => MyInputField4(
                      isPasswordField: true,
                      hint: "Password",
                      suffix: IconButton(
                        icon: Icon(
                          showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          showPassword.value = !showPassword.value;
                        },
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Password is required';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(val)) {
                          return 'Password must contain only numbers';
                        }
                        if (val.length < 6) {
                          return 'Password must be at least 6 digits';
                        }
                        return null;
                      },
                      onChange: (val) {
                        password = val!;
                      },
                      obscureText: !showPassword.value,
                      onChanged: (value) {},
                      initialValue: '',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                        () => MyInputField4(
                      isPasswordField: true,
                      hint: "Confirm Password",
                      suffix: IconButton(
                        icon: Icon(
                          showConfirmPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          showConfirmPassword.value =
                          !showConfirmPassword.value;
                        },
                      ),
                      validator: (val) {
                        if (val != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onChange: (val) {
                        confirmPassword = val!;
                      },
                      obscureText: !showConfirmPassword.value,
                      onChanged: (value) {},
                      initialValue: '',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                        value: isChecked.value,
                        onChanged: (bool? value) {
                          isChecked.value = value ?? false;
                        },
                      )),
                      GestureDetector(
                        onTap: () {
                          Get.to(TermsAndPoliciesScreen());// Handle the "terms & policy" tap event here
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "I understood the ",
                            style: TextStyle(
                                color: Colors.black, fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                text: "terms & policy.",
                                style: TextStyle(
                                    color: Color(0xff21AF85),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  MyCustomButton(
                    text: "Sign Up",
                    width: 200,
                    loading: loading.value,
                    onTap: () async {
                      if (!isChecked.value) {
                        Get.snackbar(
                          "Terms & Policy",
                          "Please check the terms & policy to continue.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.black,
                        );
                      } else if (_formKey.currentState!.validate()) {
                        loading.value = true;
                        dynamic result = await _auth
                            .signUpWithEmailAndPassword(
                            fullName, email, password, confirmPassword);
                        if (result == null) {
                          error = 'Please enter a valid email';
                          loading.value = false;
                          Get.snackbar(
                            "Sign Up Failed",
                            error,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.black,
                          );
                        } else {
                          // Send the welcome notification after successful signup
                          await sendWelcomeNotification(email);

                          Get.to(const ScreenGetStarted());
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 100),
                  GestureDetector(
                    onTap: () {
                      Get.to(const ScreenLogin());
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Have an account? ",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Login.",
                            style: TextStyle(
                                color: Color(0xff21AF85),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class SquareTile extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const SquareTile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Image.asset(
          imagePath,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}

Future<void> sendWelcomeNotification(String userEmail) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('notifications')
        .add({
      'title': 'Welcome to Mental health chatbot Connect!',
      'message': 'Thank you for signing up. We are glad to have you!',
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("Error sending welcome notification: $e");
  }
}
