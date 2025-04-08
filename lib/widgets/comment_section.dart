import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentSection extends StatefulWidget {
  final String eventId;

  const CommentSection({required this.eventId, super.key});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    fetchCommentsWithUsers();
  }

  Future<void> fetchCommentsWithUsers() async {
  final commentSnapshot = await FirebaseFirestore.instance
      .collection('Comments')
      .where('eventId', isEqualTo: widget.eventId)
      .get();

  final rawComments = commentSnapshot.docs.map((doc) => doc.data()).toList();

  // Yorumlara kullanıcı bilgilerini ekle
  for (var comment in rawComments) {
    final userId = comment['userId'];

    // Kullanıcı bilgilerini al
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    final user = userSnapshot.data();
    comment['user'] = user;

    // Alt yorumları al (commentOfComments id'sine göre)
    final childComments = rawComments.where((c) => c['commentOfComments'] == comment['id']).toList();
    comment['replies'] = childComments;
  }

  setState(() {
    comments = rawComments;
  });
}


  @override
  Widget build(BuildContext context) {
    return comments.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final mainComment = comments[index];
              return CommentTile(
                comment: mainComment,
                replies: mainComment['replies'] ?? [],
              );
            },
          );
  }
}




class CommentTile extends StatelessWidget {
  final Map<String, dynamic> comment;
  final List<Map<String, dynamic>> replies;

  const CommentTile({required this.comment, required this.replies, super.key});

  @override
  Widget build(BuildContext context) {
    final user = comment['user'];
    final userName = user?['name'] ?? 'Bilinmeyen';
    final profileImage = user?['profileImage'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Alt yorumları burada ekliyoruz
        ...replies.map((reply) {
          final replyUser = reply['user'];
          final replyName = replyUser?['name'] ?? 'Bilinmeyen';
          final replyProfileImage = replyUser?['profileImage'] ?? '';

          return Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(replyProfileImage),
                child: replyProfileImage.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(replyName),
              subtitle: Text(reply['text'] ?? ''),
            ),
          );
        }).toList(),
        const Divider(),
      ],
    );
  }
}
