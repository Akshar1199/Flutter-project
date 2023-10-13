class Answer {
  String? questionId;
  String? answerId;
  final String answerText;
  final String userId;
  final String userName;
  int? upvoteCount;
  Answer({
    this.answerId,
    this.upvoteCount = 0,
    required this.questionId,
    required this.answerText,
    required this.userId,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'answerId': questionId,
      'questionId': questionId,
      'answerText': answerText,
      'userId': userId,
      'userName': userName,
      'upvoteCount': upvoteCount,
    };
  }
}
