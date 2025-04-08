import 'package:firebase_auth/firebase_auth.dart';

class Comment {
  final String id;
  final String text;
  final User? user;
  final String? commentOfComments;

  Comment({
    required this.id,
    required this.text,
    this.user,
    this.commentOfComments,
  });

  factory Comment.fromMap(String id, Map<String, dynamic> data, [User? user]) {
    return Comment(
      id: id,
      text: data['text'] ?? '',
      user: user,
      commentOfComments: data['commentOfComments'],
    );
  }
}
