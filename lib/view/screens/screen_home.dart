import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mental_health_chatbot/view/layouts/layout_dairy.dart';
import 'package:mental_health_chatbot/view/layouts/layout_profile.dart';
import 'package:mental_health_chatbot/view/screens/screen_chat.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/my_custom_button.dart';
import '../../widgets/small_text.dart';
import '../layouts/layout_notification.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  // Using a ValueNotifier to manage the selected index for the bottom navigation bar
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    // Pages corresponding to each bottom navigation item
    final List<Widget> pages = [
      const LayoutHome(),
      LayoutDairy(),
      LayoutProfile(),
      UserNotificationsScreen(),
    ];
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _selectedIndexNotifier,
        builder: (context, selectedIndex, child) {
          return IndexedStack(
            index: selectedIndex,
            children: pages,
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndexNotifier,
        builder: (context, selectedIndex, child) {
          return BottomNavigationBar(
            currentIndex: selectedIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              _selectedIndexNotifier.value = index;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_alt_sharp),
                label: 'dairy',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),

            ],
          );
        },
      ),
    );
  }
}
class LayoutHome extends StatelessWidget {
  const LayoutHome({super.key});

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
              SmallText(text:"Hi! I'm your friendly chatbot here to help and chat with you. ",color: Colors.black,), // Add meaningful text here
              const SizedBox(height: 50),
              MyCustomButton(text:"Start Chat", width: 200,loading: false, onTap: (){
                // Get.to(ScreenAllSevereSpeechTherapy()
                Get.to(MentalCheckScreen() );
                //Get.to(ScreenStartConversation()

              }),
              const SizedBox(height: 50),// Show progress indicator
            ],
          ),
        ),
      ),
    );
  }
}
