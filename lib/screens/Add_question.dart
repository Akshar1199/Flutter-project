import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class Question {
  final String title;
  final String details;
  final String userId;
  final List<String>? answers;
  final String? tried;
  final String? expected;

  Question({
    required this.title,
    required this.details,
    required this.userId,
    this.answers,
    this.tried,
    this.expected,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'details': details,
      'userId': userId,
      'answers': answers,
      'tried': tried,
      'expected': expected,
    };
  }
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  String userid = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController triedController = TextEditingController();
  final TextEditingController expectedController = TextEditingController();
  bool isDetailsEnabled = false; // Track if details should be enabled
  bool isTriedEnabled = false; // Track if "What did you try?" should be enabled

  void initState() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('user_uid') ?? '';
    });
  }

  void submitQuestion() async {
    if (_formKey.currentState!.validate()) {
      final question = Question(
        title: titleController.text,
        details: detailsController.text,
        userId: userid, // Replace with the actual user ID
        tried: triedController.text,
        expected: expectedController.text,
      );

      final questionsCollection =
          FirebaseFirestore.instance.collection('questions');
      await questionsCollection.add(question.toMap());

      Navigator.pop(context); // Close the form screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    // Enable the details field when the title is entered
                    isDetailsEnabled = value.isNotEmpty;
                  });
                },
              ),
              TextFormField(
                controller: detailsController,
                decoration: InputDecoration(
                  labelText: 'Details',
                  // Disable the details field when isDetailsEnabled is false
                  enabled: isDetailsEnabled,
                ),
                validator: (value) {
                  if (!isDetailsEnabled) {
                    return 'Please enter a title first';
                  }
                  if (value!.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    // Enable the details field when the title is entered
                    isTriedEnabled = value.isNotEmpty;
                  });
                },
              ),
              TextFormField(
                controller: triedController,
                decoration: InputDecoration(
                  labelText: 'What did you try?',
                  // Disable the "What did you try?" field when isTriedEnabled is false
                  enabled: isTriedEnabled,
                ),
                validator: (value) {
                  if (!isTriedEnabled) {
                    return 'Please enter details first';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: expectedController,
                decoration: InputDecoration(
                  labelText: 'What were you expecting?',
                  enabled: isTriedEnabled,
                ),
                validator: (value) {
                  if (!isTriedEnabled) {
                    return 'Please enter details first';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: submitQuestion,
                child: Text('Add Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
