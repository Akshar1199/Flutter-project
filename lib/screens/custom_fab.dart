import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Add your onPressed logic here
      },
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }
}
