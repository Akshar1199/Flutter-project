import 'package:auth/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reusable_code/reusable.dart';
import '../utils/color_utils.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

bool isEmailValid(String email) {
  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/img.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 5,
                ),
                firebaseUIButton(context, "Sign In", () {
                  final email = _emailTextController.text;
                  final password = _passwordTextController.text;

                  if (!isEmailValid(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid email format."),
                      ),
                    );
                    return;
                  }

                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  )
                      .then((value) async {
                    String? tempurl;
                    try {
                      final snapshot = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(value.user?.uid ?? '')
                          .collection("images")
                          .limit(1)
                          .get();

                      if (snapshot.docs.isNotEmpty) {
                        final firstDoc = snapshot.docs.first;
                        tempurl = firstDoc['downloadURL'];
                      } else {
                        print("Error retrieving");
                      }
                    } catch (e) {
                      print("Error retrieving image URL: $e");
                    }
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('user_email', email);
                    prefs.setString('user_uid', value.user?.uid ?? '');
                    prefs.setString(
                        'user_profile_photo_url',
                        tempurl ??
                            'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }).catchError((error) {
                    print("Error ${error.toString()}");
                    if (error.toString().contains("wrong-password")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Incorrect password."),
                        ),
                      );
                    } else if (error.toString().contains("user-not-found")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("User not found with this email address."),
                        ),
                      );
                    } else {}
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Get.toNamed('/signup');
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  // Widget forgetPassword(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: 35,
  //     alignment: Alignment.bottomRight,
  //     // child: TextButton(
  //     //   child: const Text(
  //     //     "Forgot Password?",
  //     //     style: TextStyle(color: Colors.white70),
  //     //     textAlign: TextAlign.right,
  //     //   ),
  //     //   onPressed: () => Navigator.push(
  //     //       context, MaterialPageRoute(builder: (context) => ResetPassword())),
  //     // ),
  //   );
  // }
}
