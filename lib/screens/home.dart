import 'package:auth/screens/common_bottom_navigation_bar.dart';
import 'package:auth/screens/custom_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reusable_code/reusable.dart';
import 'profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  void initState() {
    _loadUserData();
  }

  String profilePhotoUrl = '';
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePhotoUrl = prefs.getString('user_profile_photo_url') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Home',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: (int index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              break;
            case 1:
              Get.toNamed('/profile');
              break;
          }
        },
        profilePhotoUrl: profilePhotoUrl,
      ),
      floatingActionButton:
          CustomFloatingActionButton(), // No onPressed needed here
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

      // // body: Center(
      // //   child: ElevatedButton(
      // //     child: Text("Logout"),
      // //     onPressed: () {
      // //       FirebaseAuth.instance.signOut().then((value) {
      // //         print("Signed Out");
      // //         Navigator.push(context,
      // //             MaterialPageRoute(builder: (context) => SignInScreen()));
      // //       });
      // //     },
      // //   ),
      // ),