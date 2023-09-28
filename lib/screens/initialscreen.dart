import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Navigate to the login screen when the "Login" button in the app bar is pressed.
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
              // Navigate to the signup screen when the "Sign Up" button in the app bar is pressed.
              Get.toNamed('/signup');
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white, // Customize the button text color.
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to the login screen when the "Login" button in the app bar is pressed.
              // Get.toNamed('/signin');
            },
            child: Text(
              'About',
              style: TextStyle(
                color: Colors.white, // Customize the button text color.
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
