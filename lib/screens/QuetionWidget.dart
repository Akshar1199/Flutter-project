import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionWidget extends StatelessWidget {
  final DocumentSnapshot question;
  final Function upvoteCallback;
  final Function downvoteCallback;

  QuestionWidget({
    required this.question,
    required this.upvoteCallback,
    required this.downvoteCallback,
  });

  @override
  Widget build(BuildContext context) {
    final title = question['title'];
    final details = question['details'];
    final upVote = question['upVote'];
    final username = question['username'];

    return Card(
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
                    upvoteCallback(question);
                  },
                  child: Text('Upvote Question'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    downvoteCallback(question);
                  },
                  child: Text('Downvote Question'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
