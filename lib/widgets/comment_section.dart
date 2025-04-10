import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentSection extends StatefulWidget {
  final String eventId;

  const CommentSection({required this.eventId, super.key});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  List<Map<String, dynamic>> comments = [];
  final TextEditingController _commentController = TextEditingController();

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

    final rawComments = commentSnapshot.docs.map((doc) {
      var data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    for (var comment in rawComments) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(comment['userId'])
          .get();
      comment['user'] = userSnapshot.data();

    final replySnapshot = await FirebaseFirestore.instance
          .collection('commentOfComment')
          .where('commentId', isEqualTo: comment['id'])
          .get();

      final replies = replySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      for (var reply in replies) {
        final replyUserSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(reply['userId'])
            .get();
        reply['user'] = replyUserSnapshot.data();
      }

      comment['replies'] = replies;
    }

    setState(() {
      comments = rawComments;
    });
  }

  Future<void> addComment(String text) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await FirebaseFirestore.instance.collection('Comments').add({
      'eventId': widget.eventId,
      'userId': currentUser.uid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
    fetchCommentsWithUsers();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        if (currentUser != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Yorum yaz...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_commentController.text.trim().isNotEmpty) {
                      addComment(_commentController.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        Expanded(
          child: comments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return CommentTile(
                      comment: comment,
                      replies: comment['replies'] ?? [],
                      onReplyAdded: fetchCommentsWithUsers,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class CommentTile extends StatelessWidget {
  final Map<String, dynamic> comment;
  final List<Map<String, dynamic>> replies;
  final VoidCallback onReplyAdded;

  const CommentTile({
    required this.comment,
    required this.replies,
    required this.onReplyAdded,
    super.key,
  });

  Future<void> addReply(String text) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await FirebaseFirestore.instance.collection('commentOfComment').add({
      'commentId': comment['id'],
      'userId': currentUser.uid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });

    onReplyAdded();
  }

  @override
  Widget build(BuildContext context) {
    final user = comment['user'];
    final userName = user?['name'] ?? 'Bilinmeyen';
    final profileImage = user?['profileImage'] ?? '';

    final TextEditingController replyController = TextEditingController();
    final currentUser = FirebaseAuth.instance.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: profileImage.isNotEmpty
                ? NetworkImage(profileImage)
                : null,
            child: profileImage.isEmpty ? const Icon(Icons.person) : null,
          ),
          title: Text(userName),
          subtitle: Text(comment['text']),
        ),
        ...replies.map((reply) {
          final replyUser = reply['user'];
          final replyName = replyUser?['name'] ?? 'Bilinmeyen';
          final replyProfileImage = replyUser?['profileImage'] ?? '';
          return Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: replyProfileImage.isNotEmpty
                    ? NetworkImage(replyProfileImage)
                    : null,
                child: replyProfileImage.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(replyName),
              subtitle: Text(reply['text']),
            ),
          );
        }).toList(),
        if (currentUser != null)
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 8.0, bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyController,
                    decoration: const InputDecoration(
                      hintText: 'Yanıtla...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.reply),
                  onPressed: () {
                    if (replyController.text.trim().isNotEmpty) {
                      addReply(replyController.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        const Divider(),
      ],
    );
  }
}
