import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mental_health_chatbot/view/screens/screen_forget.dart';
import 'package:mental_health_chatbot/view/screens/screen_get_started.dart';
import 'package:mental_health_chatbot/view/screens/screen_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../../widgets/my_custom_button.dart';
import '../../widgets/my_input_field3.dart';
import '../../widgets/my_input_field4.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  bool isChecked = false;
  bool _obscurePassword = true; // Toggle for password visibility
  final AuthService _auth = AuthService();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  // Load saved email and password from SharedPreferences
  Future<void> _loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
      password = prefs.getString('password') ?? '';
      isChecked = prefs.getBool('isChecked') ?? false;
    });
  }

  // Save email and password to SharedPreferences
  Future<void> _saveUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('isChecked', isChecked);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('isChecked', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff21AF85),
        centerTitle: true,
        title: const Text(
          "Login",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Image.asset("assets/images/login.png"),
              const SizedBox(height: 35),
              MyInputField3(
                hint: "Email",
                obscureText: false,
                initialValue: email,
                onChange: (val) {
                  setState(() {
                    email = val!;
                  });
                },
              ),
              const SizedBox(height: 8),
              MyInputField4(
                hint: "Password",
                isPasswordField: true,
                obscureText: _obscurePassword,
                initialValue: password,
                onChange: (val) {
                  setState(() {
                    password = val!;
                  });
                },
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                onChanged: (value) {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Text(
                        "Remember me",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(const ScreenForget());
                    },
                    child: const Text(
                      "Forget Password",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              MyCustomButton(
                text: "Login",
                width: 200,
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });

                  dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                  if (result == null) {
                    setState(() {
                      loading = false;
                      error = 'Please enter a valid email or password';
                    });

                    Get.snackbar(
                      "Login Failed",
                      error,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.black,
                    );
                  } else {
                    await _saveUserCredentials();
                    Get.to(ScreenGetStarted());

                  }
                },
                margin: 12,
              ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Get.to( ScreenSignup());
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text: "SignUp.",
                        style: TextStyle(
                            color: Color(0xff21AF85),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
