import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed('/Addquestion');
      },
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }
}
