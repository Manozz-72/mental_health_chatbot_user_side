import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../controller/controller_edit_profile.dart';
import '../../services/database.dart';
import '../screens/screen_about.dart';
import '../screens/screen_edit_profile.dart';
import '../screens/screen_login.dart';

class LayoutProfile extends StatefulWidget {
  const LayoutProfile({super.key});

  @override
  _LayoutProfileState createState() => _LayoutProfileState();
}

class _LayoutProfileState extends State<LayoutProfile> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ControllerEditProfile controller = Get.put(ControllerEditProfile());

  String userName = '';
  String userEmail = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      String email = user.email ?? '';
      var userData = await DatabaseService().getUserData(email);

      setState(() {
        userName = userData?['name'] ?? 'User';
        userEmail = userData?['email'] ?? 'No email';
        profileImageUrl = userData?['profileImageUrl'] ?? '';
      });
    }
  }

  String _generateGravatarUrl(String email) {
    final bytes = utf8.encode(email.trim().toLowerCase());
    final hash = sha256.convert(bytes).toString();
    return 'https://www.gravatar.com/avatar/$hash?d=identicon&s=200';
  }

  @override
  Widget build(BuildContext context) {
    String displayImage = profileImageUrl.isNotEmpty
        ? profileImageUrl
        : _generateGravatarUrl(userEmail);

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffEAF7F3), // Light greenish background
          border: const Border(
            right: BorderSide(
              color: Colors.black, // Darker green side line
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff21AF85), Color(0xff0B8EAB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: displayImage.isNotEmpty
                        ? NetworkImage(displayImage)
                        : const AssetImage('assets/images/profileImageUrl.png')
                    as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.person_outlined,
                    text: "Update Profile",
                    onTap: () {
                      Get.to(() => ScreenEditProfile())?.then((_) {
                        _loadUserData();
                      });
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.account_balance_outlined,
                    text: "About",
                    onTap: () {
                      Get.to(() => const ScreenAbout());
                    },
                  ),

                  _buildDrawerItem(
                    icon: Icons.logout,
                    text: "Log Out",
                    color: Colors.redAccent,
                    onTap: () async {
                      bool confirmLogout = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Log Out"),
                          content:
                          const Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(true),
                              child: const Text(
                                "Log Out",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirmLogout) {
                        await _firebaseAuth.signOut();
                        Get.offAll(() => const ScreenLogin());
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = const Color(0xff0B8EAB),
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: Colors.teal.withOpacity(0.1),
      splashColor: Colors.teal.withOpacity(0.2),
    );
  }
}
