import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Add_question.dart';
import 'QuestionDetailPage.dart';

class SearchScreen extends StatefulWidget {
  final List<DocumentSnapshot> allQuestions;
  final Function fetchQuestionsCallback;

  SearchScreen(this.allQuestions, this.fetchQuestionsCallback);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<DocumentSnapshot> searchResults = [];
  TextEditingController searchController = TextEditingController();

  void filterQuestions(String query) {
    setState(() {
      searchResults = widget.allQuestions.where((question) {
        final title = question['title'].toString().toLowerCase();
        final details = question['details'].toString().toLowerCase();
        final keywords = title.split(' ') + details.split(' ');

        return keywords
                .any((keyword) => keyword.contains(query.toLowerCase())) ||
            (title.contains(query.toLowerCase()) ||
                details.contains(query.toLowerCase()));
      }).toList();
    });
  }

  void performSearch() {
    final query = searchController.text;
    filterQuestions(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Questions'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Questions',
              ),
              onChanged: (query) {
                // You can handle real-time filtering here if needed.
              },
            ),
          ),
          ElevatedButton(
            onPressed: performSearch,
            child: Text('Search'),
          ),
          // Display search results in a ListView.builder or any other suitable widget.
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Text('No questions found'),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final question = searchResults[index];
                      final title = question['title'];
                      final details = question['details'];
                      final questionData =
                          question.data() as Map<String, dynamic>;
                      final username = questionData['username'];

                      return GestureDetector(
                          onTap: () async {
                            // final questionData = question;
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
                                  // fetchQuestionsCallback: _fetchQuestions,
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
                          ));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
