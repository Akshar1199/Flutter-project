import 'package:Stackoverflow/screens/About.dart';
import 'package:Stackoverflow/screens/Add_question.dart';
import 'package:Stackoverflow/screens/SearchScreen.dart';
import 'package:Stackoverflow/screens/home.dart';
import 'package:Stackoverflow/screens/initialscreen.dart';
import 'package:Stackoverflow/screens/profile.dart';
import 'package:Stackoverflow/screens/signin.dart';
import 'package:Stackoverflow/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final QuestionController questionController = Get.put(QuestionController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/initial',
      getPages: [
        GetPage(name: '/initial', page: () => IntialPage()),
        GetPage(name: '/signin', page: () => SignInScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(
            name: '/Addquestion',
            page: () => AddQuestionScreen(
                  fetchQuestionsCallback: () {},
                )),
        GetPage(name: '/about', page: () => AboutUsPage()),
      ],
    );
  }
}
