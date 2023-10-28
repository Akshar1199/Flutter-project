import 'package:Stackoverflow/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'initialscreen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) async {
        print("Signed Out");
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('user_email');
        prefs.remove('user_uid');
        prefs.remove('user_username');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => IntialPage()));
      });
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  CustomAppBar({
    required this.title,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            _signOut(context);
          },
        ),
      ],
    );
  }
}
