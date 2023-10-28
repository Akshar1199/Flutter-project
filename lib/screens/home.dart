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
import 'SearchScreen.dart';
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
  bool isSearching = false;

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

  Future<void> deleteQuestion(String questionId, String userId) async {
    final user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null && user.uid == userId) {
      // The user can delete their own question
      try {
        await FirebaseFirestore.instance
            .collection('questions')
            .doc(questionId)
            .delete();
        print('Question deleted successfully');
      } catch (e) {
        print('Error deleting question: $e');
      }
    } else {
      // Handle the case where the user is not authorized to delete the question.
    }
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
      appBar: AppBar(
        title: Text('All Questions'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SearchScreen(allquestions, _fetchQuestions),
                ),
              );
            },
          ),
        ],
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
                  // final upVote = questionData['upVote'];

                  Color cardBackgroundColor = Colors.black12;

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
                          tried: questionData['tried'],
                          expected: questionData['expected'],
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionDetailPage(
                              question: questionObject,
                              // fetchQuestionsCallback: _fetchQuestions,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color:
                            cardBackgroundColor, // Set the background color here
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(title),
                                subtitle: Text(details),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  '$username',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 3),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalPages, (index) {
                    final page = index + 1;
                    final isSelected = _currentPage == page;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                          8.0, 8.0, 8.0, 7.0), // Adjust the spacing
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentPage = page;
                          });
                          _setquestions();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: isSelected ? Colors.white60 : Colors.deepPurpleAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          '$page',
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(width: 23), // Add a SizedBox with a specific width
            Container(
              padding: EdgeInsets.only(bottom: 23),
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent)
                      ),
                    SizedBox(width: 16), // Add a SizedBox with a specific width
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent)
                      ),
                  ],
                ),
              ),
            ),
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
        backgroundColor: Colors.indigoAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
