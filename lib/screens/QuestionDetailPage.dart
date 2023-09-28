import 'package:auth/screens/Add_question.dart';
import 'package:flutter/material.dart';

class QuestionDetailPage extends StatelessWidget {
  final Question question; // Accept the entire Question object

  QuestionDetailPage(
      {required this.question}); // Constructor with the Question parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: ${question.title}'),
            Text('Details: ${question.details}'),
            // Display other question properties as needed
          ],
        ),
      ),
    );
  }
}
