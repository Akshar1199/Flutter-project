import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reusable_code/reusable.dart';
import '../utils/color_utils.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  // TextEditingController _confirmPasswordController = TextEditingController();

  // void _signUp() async {
  //   String user =  _userNameTextController.text.trim();
  //   String email = _emailTextController.text.trim();
  //   String pass = _passwordTextController.text.trim();
  //   // String cPass = _confirmPasswordController.text.trim();
  //
  //   if(email == "" || pass == "" ||  user == ""){
  //     log("please fill all the details!");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('please fill all the details!'),
  //           duration: Duration(seconds: 4),
  //         )
  //     );
  //   }
  //   // else if(){
  //   //
  //   //   log("password do not match!");
  //   //   ScaffoldMessenger.of(context).showSnackBar(
  //   //       SnackBar(
  //   //         content: Text('Passwords do not match!'),
  //   //         duration: Duration(seconds: 4),
  //   //       )
  //   //   );
  //   }
  //   else if(pass.length() < 5) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //               'weak-password : Password should be at least 6 characters'),
  //           duration: Duration(seconds: 4),
  //         )
  //     );
  //   }
  //   else{
  //
  //     try{
  //       UserCredential userAccount = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
  //       log("account created!");
  //       if(userAccount.user != null){
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomeScreen()),
  //         );
  //       }
  //     }
  //     on FirebaseAuthException catch(e) {
  //       log(e.toString());
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(e.toString()),
  //             duration: Duration(seconds: 4),
  //           )
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) async {
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('users');
                    await users.doc(value.user!.uid).set({
                      'username': _userNameTextController.text,
                    });
                    print("Created New Account");
                    String? tempurl;
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('user_email', _emailTextController.text);
                    prefs.setString('user_uid', value.user?.uid ?? '');
                    prefs.setString(
                        'user_profile_photo_url',
                        tempurl ??
                            'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png');
                    Get.toNamed('/home');
                  }).catchError((error) {
                    print("Error ${error.toString()}");
                    if (error.toString().contains("email-already-in-use")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "User already exists with this email address."),
                        ),
                      );
                    } else if (error.toString().contains("weak-password")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Password should be at least 6 characters.",
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "An error occurred: ${error.toString()}",
                          ),
                        ),
                      );
                    }
                  });
                })
              ],
            ),
          ))),
    );
  }
}
