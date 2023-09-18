import 'dart:io';

import 'package:auth/screens/common_bottom_navigation_bar.dart';
import 'package:auth/screens/custom_app_bar.dart';
import 'package:auth/screens/custom_fab.dart';
import 'package:auth/screens/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedImage;
  File? _image;
  String? downloadURL;
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      _image = tempImage;
      uploadImage();
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  String userId = '';
  String email = '';
  String profilePhotoUrl = '';
  Future uploadImage() async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$userId/images')
        .child("post_$imgId");
    await storageReference.putFile(_image!);
    downloadURL = await storageReference.getDownloadURL();
    print(downloadURL);
    await firebaseFirestore
        .collection("users")
        .doc(userId)
        .collection("images")
        .add({'downloadURL': downloadURL}).whenComplete(
            () => showSnackBar("Image Uploaded", Duration(seconds: 2)));

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_profile_photo_url', downloadURL!);
    setState(() {
      profilePhotoUrl = downloadURL!;
    });
  }

  @override
  void initState() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('user_email') ?? '';
      userId = prefs.getString('user_uid') ?? '';
      profilePhotoUrl = prefs.getString('user_profile_photo_url') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var _currentIndex = 1;
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: ClipOval(
                    child: pickedImage != null
                        ? Image.file(
                            pickedImage!,
                            width: 170,
                            height: 170,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            profilePhotoUrl,
                            width: 170,
                            height: 170,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 5,
                  child: IconButton(
                    onPressed: imagePickerOption,
                    icon: const Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
                onPressed: imagePickerOption,
                icon: const Icon(Icons.add_a_photo_sharp),
                label: const Text('UPLOAD IMAGE')),
          ),
          SizedBox(height: 10),
          Text(
            'Email: $email',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: (int index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Get.toNamed('/home');
              break;
            case 1:
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

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
