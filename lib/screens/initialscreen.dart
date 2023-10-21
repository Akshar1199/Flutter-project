import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntialPage extends StatefulWidget {
  @override
  _IntialPageState createState() => _IntialPageState();
}

class _IntialPageState extends State<IntialPage> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_uid');

    if (userId != null) {
      Get.toNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.toNamed('/signin');
            },
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.white, // Customize the button text color.
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed('/signup');
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white, // Use Colors.white for white color
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.toNamed('/about');
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white, // Use Colors.white for white color
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to our App!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
