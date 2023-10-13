import 'package:Stackoverflow/screens/Add_question.dart';
import 'package:Stackoverflow/screens/QuestionDetailPage.dart';
import 'package:Stackoverflow/screens/common_bottom_navigation_bar.dart';
import 'package:Stackoverflow/screens/custom_fab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Stackoverflow/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../reusable_code/reusable.dart';
import 'profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _currentPage = 1;
  int _questionsPerPage = 8;
  int _totalPages = 1;

  List<DocumentSnapshot> questions = [];
  List<DocumentSnapshot> allquestions = [];

  @override
  void initState() {
    _loadUserData();
    _fetchQuestions();
  }

  String profilePhotoUrl = '';
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePhotoUrl = prefs.getString('user_profile_photo_url') ?? '';
    });
  }

  Future<void> _fetchQuestions() async {
    final questionData = await fetchQuestions();
    allquestions = questionData;
    setState(() {
      final start = (_currentPage - 1) * _questionsPerPage;
      final end = start + _questionsPerPage;

      if (end > allquestions.length) {
        questions = allquestions.sublist(start, (allquestions.length));
      } else {
        questions = allquestions.sublist(start, end);
      }
      _totalPages = (allquestions.length / _questionsPerPage).ceil();
    });
  }

  Future<void> _setquestions() async {
    setState(() {
      final start = (_currentPage - 1) * _questionsPerPage;
      final end = start + _questionsPerPage;
      if (end > allquestions.length) {
        questions = allquestions.sublist(start, (allquestions.length));
      } else {
        questions = allquestions.sublist(start, end);
      }
    });
  }

  Future<List<DocumentSnapshot>> fetchQuestions() async {
    final QuerySnapshot questionSnapshot =
        await FirebaseFirestore.instance.collection('questions').get();
    return questionSnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'All Questions',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final title = question['title'];
                  final details = question['details'];
                  final qid = question['questionId'];
                  final questionData = question.data() as Map<String, dynamic>;
                  final username = questionData['username'];
                  final upVote = questionData['upVote'];
                  Future<void> updateupvotequestion(
                      DocumentSnapshot question) async {
                    final questionRef = FirebaseFirestore.instance
                        .collection('questions')
                        .doc(question['questionId']);
                    int currentUpvotes = question['upVote'];

                    await questionRef.update({
                      'upVote': currentUpvotes + 1,
                    });
                    _fetchQuestions();
                  }

                  Future<void> updatedownvotequestion(
                      DocumentSnapshot question) async {
                    final questionRef = FirebaseFirestore.instance
                        .collection('questions')
                        .doc(question['questionId']);
                    int currentUpvotes = question['upVote'];

                    await questionRef.update({
                      'upVote': currentUpvotes - 1,
                    });
                    _fetchQuestions();
                  }

                  return GestureDetector(
                      onTap: () async {
                        final questionObject = Question(
                          title: questionData['title'],
                          details: questionData['details'],
                          userId: questionData['userId'],
                          username: questionData['username'],
                          questionId: questionData['questionId'],
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionDetailPage(
                              question: questionObject,
                              fetchQuestionsCallback: _fetchQuestions,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(title),
                              subtitle: Text(details),
                              trailing: Text(
                                'votes: $upVote',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                '$username',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      updateupvotequestion(questions[index]);
                                    },
                                    child: Text('Upvote Question'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right:
                                          16.0), // Add space between Upvote and Downvote
                                  child: ElevatedButton(
                                    onPressed: () {
                                      updatedownvotequestion(questions[index]);
                                    },
                                    child: Text('Downvote Question'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentPage > 1)
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage > 1) {
                            setState(() {
                              _currentPage--;
                            });
                            _setquestions();
                          }
                        },
                        child: Text('Previous Page'),
                      ),
                    SizedBox(width: 16),
                    if (_currentPage < _totalPages)
                      ElevatedButton(
                        onPressed: () {
                          if (allquestions.length -
                                  (_currentPage * _questionsPerPage) >
                              0) {
                            setState(() {
                              _currentPage++;
                            });
                            _setquestions();
                            print(
                                "Next Page Button Clicked. Current Page: $_currentPage");
                          }
                        },
                        child: Text('Next Page'),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 23),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 16),
                    for (int i = 1; i <= _totalPages; i++)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentPage = i;
                          });
                          _setquestions();
                        },
                        child: Text('$i'),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: (int index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              break;
            case 1:
              Get.toNamed('/profile');
              break;
          }
        },
        profilePhotoUrl: profilePhotoUrl,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddQuestionScreen(
                fetchQuestionsCallback: _fetchQuestions, // Pass the callback
              ),
            ),
          );
        },
        child: Icon(Icons.add), // You can change the icon to your preference
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Widget _buildPageNumberBar() {
  //   return Container(
  //       padding:
  //           EdgeInsets.only(bottom: 30), // Adjust the top padding as needed
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text('Page $_currentPage of $_totalPages'),
  //         ],
  //       ));
  // }
}

      // // body: Center(
      // //   child: ElevatedButton(
      // //     child: Text("Logout"),
      // //     onPressed: () {
      // //       FirebaseAuth.instance.signOut().then((value) {
      // //         print("Signed Out");
      // //         Navigator.push(context,
      // //             MaterialPageRoute(builder: (context) => SignInScreen()));
      // //       });
      // //     },
      // //   ),
      // ),