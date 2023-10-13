import 'package:Stackoverflow/screens/Add_question.dart';
import 'package:Stackoverflow/screens/Answer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionDetailPage extends StatefulWidget {
  final Question question;
  final VoidCallback fetchQuestionsCallback;

  QuestionDetailPage(
      {required this.question, required this.fetchQuestionsCallback});

  @override
  _QuestionDetailPageState createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  bool isAddingAnswer = false;
  final TextEditingController answerController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<DocumentSnapshot> answers = [];

  Future<void> fetchAnswers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('answer')
        .where('questionId', isEqualTo: widget.question.questionId)
        .get();

    final fetchedAnswers = querySnapshot.docs;

    setState(() {
      answers = fetchedAnswers;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAnswers();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.question.upVote);
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              buildTextRow("Title:", widget.question.title),
              SizedBox(height: 8),
              buildTextRow("Details:", widget.question.details),
              SizedBox(height: 16),
              if (!isAddingAnswer)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isAddingAnswer = true;
                    });
                  },
                  child: Text('Add Your Answer'),
                ),
              if (isAddingAnswer)
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Answer:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: answerController,
                        decoration: InputDecoration(
                          labelText: 'Answer',
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide an answer';
                          }
                          return null; // Return null if the input is valid
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitAnswerToFirebase();
                            setState(() {
                              isAddingAnswer = false;
                            });
                          }
                        },
                        child: Text('Submit Answer'),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              Text(
                'Answers:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: answers.length,
                  itemBuilder: (context, index) {
                    final answerData =
                        answers[index].data() as Map<String, dynamic>;
                    final answerText = answerData['answerText'] as String;
                    final answeruser = answerData['userName'] as String;

                    int? upvoteCount = answerData['upvoteCount'];

                    void handleUpvote(DocumentSnapshot answerDoc) async {
                      final answerRef = FirebaseFirestore.instance
                          .collection('answer')
                          .doc(answerDoc.id);
                      final currentUpvotes = answerDoc['upvoteCount'] ?? 0;

                      await answerRef.update({
                        'upvoteCount': currentUpvotes + 1,
                      });
                      fetchAnswers();
                    }

                    void handleDownvote(DocumentSnapshot answerDoc) async {
                      final answerRef = FirebaseFirestore.instance
                          .collection('answer')
                          .doc(answerDoc.id);
                      final currentUpvotes = answerDoc['upvoteCount'] ?? 0;

                      await answerRef.update({
                        'upvoteCount': currentUpvotes - 1,
                      });
                      fetchAnswers();
                    }

                    return Card(
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Answer ${index + 1}:',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'User: $answeruser',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Answer: $answerText',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                'Upvotes: $upvoteCount',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right:
                                            16.0), // Add space between Upvote and Downvote
                                    child: ElevatedButton(
                                      onPressed: () {
                                        handleUpvote(answers[index]);
                                      },
                                      child: Text('Upvote'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right:
                                            16.0), // Add space between Upvote and Downvote
                                    child: ElevatedButton(
                                      onPressed: () {
                                        handleDownvote(answers[index]);
                                      },
                                      child: Text('Downvote'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Future<void> submitAnswerToFirebase() async {
    String answerText = answerController.text;
    final prefs = await SharedPreferences.getInstance();

    String userid = prefs.getString('user_uid') ?? '';
    String username = prefs.getString('user_username') ?? '';

    Answer answer = Answer(
      answerText: answerText,
      userId: userid,
      userName: username,
      questionId: widget.question.questionId,
    );

    final questionsCollection = FirebaseFirestore.instance.collection('answer');
    final documentReference = await questionsCollection.add({
      ...answer.toMap(),
      'answerId': '',
    });
    final answerId = documentReference.id;

    await documentReference.update({'answerId': answerId});
    answerController.clear();
    fetchAnswers();
  }
}
