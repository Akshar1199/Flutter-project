// import 'package:Stackoverflow/screens/QuestionController.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Stackoverflow/screens/home.dart';
import 'package:uuid/uuid.dart';

class AddQuestionScreen extends StatefulWidget {
  final VoidCallback fetchQuestionsCallback;
  AddQuestionScreen({required this.fetchQuestionsCallback});
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class Question {
  final String title;
  final String details;
  final String userId;
  final String username;
  final List<String>? answers;
  final String? tried;
  final String? expected;
  String? questionId;
  int? upVote;

  Question(
      {required this.title,
      required this.details,
      required this.userId,
      required this.username,
      this.answers,
      this.upVote = 0,
      this.tried,
      this.expected,
      this.questionId});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'details': details,
      'userId': userId,
      'username': username,
      'answers': answers,
      'tried': tried,
      'expected': expected,
      'questionId': questionId,
      'upVote': upVote,
    };
  }
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  String userid = '';
  String username = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController triedController = TextEditingController();
  final TextEditingController expectedController = TextEditingController();
  bool isDetailsEnabled = false;
  bool isTriedEnabled = false;

  void initState() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('user_uid') ?? '';
      username = prefs.getString('user_username') ?? '';
    });
  }

  void submitQuestion() async {
    if (_formKey.currentState!.validate()) {
      final question = Question(
        title: titleController.text,
        details: detailsController.text,
        userId: userid,
        username: username,
        tried: triedController.text,
        expected: expectedController.text,
      );

      final questionsCollection =
          FirebaseFirestore.instance.collection('questions');
      final documentReference = await questionsCollection.add({
        ...question.toMap(),
        'questionId': '',
      });
      final questionId = documentReference.id;

      await documentReference.update({'questionId': questionId});
      Navigator.pop(context);

      widget.fetchQuestionsCallback();
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
                decoration: InputDecoration(labelText: 'Title*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    isDetailsEnabled = value.isNotEmpty;
                  });
                },
              ),
              TextFormField(
                controller: detailsController,
                decoration: InputDecoration(
                  labelText: 'What are the details of your problem?*',
                  enabled: isDetailsEnabled,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    isTriedEnabled = value.isNotEmpty;
                  });
                },
              ),
              TextFormField(
                controller: triedController,
                decoration: InputDecoration(
                  labelText: 'What did you try?',
                  enabled: isTriedEnabled,
                ),
                validator: (value) {
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
