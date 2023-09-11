import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_code/reusable.dart';
import '../utils/color_utils.dart';
import 'home.dart';

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
                firebaseUIButton(context, "Sign Up",() {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    print("Created New Account");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ))),
    );
  }
}
