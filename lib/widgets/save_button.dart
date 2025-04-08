import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({super.key, required this.eventId});
  final String eventId;

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> with SingleTickerProviderStateMixin {
  bool isSaved = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late String userId;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(_controller);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {

      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userDoc = await userRef.get();
      List<dynamic> savedEvents = userDoc['savedEvents'] ?? [];

      
      setState(() {
        isSaved = savedEvents.contains(widget.eventId);
      });
   
  }

  void toggleSave() async {
    setState(() {
      isSaved = !isSaved;
    });

   
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

   
    final userDoc = await userRef.get();
    List<dynamic> savedEvents = List.from(userDoc['savedEvents'] ?? []); 

    if (isSaved) {
     
      if (!savedEvents.contains(widget.eventId)) {
        savedEvents.add(widget.eventId);
      }
      await userRef.update({
        'savedEvents': savedEvents, 
      });
    } else {
      savedEvents.remove(widget.eventId);
      await userRef.update({
        'savedEvents': savedEvents, 
      });
    }

    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSave,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved ? Colors.blue : Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}
