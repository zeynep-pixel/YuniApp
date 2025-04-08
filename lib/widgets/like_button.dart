import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget{
  const LikeButton({super.key, required this.eventId});
  final String eventId ;

  @override
  _LikeButtonState createState() => _LikeButtonState();

}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin{

  bool isLiked = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late String userId;
  
  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      duration:  const Duration(milliseconds: 200),
      vsync: this);
   _scaleAnimation = Tween<double>(begin: 1.0 , end:1.3).animate(_controller);
   final user  = FirebaseAuth.instance.currentUser;
   if(user != null){
    userId = user.uid;
   }
   _checkIfLiked();

     
  }


  Future<void> _checkIfLiked() async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userDoc = await userRef.get();
      List<dynamic> likedEvents = userDoc['likedEvents'] ?? [];

      // Eğer likedEvents dizisinde eventId varsa, isLiked'i true yapıyoruz
      setState(() {
        isLiked = likedEvents.contains(widget.eventId);
      });
    } catch (e) {
      print("Error checking if liked: $e");
    }
  }
void toggleLike() async {
  setState(() {
    isLiked = !isLiked;
  });

  final eventRef = FirebaseFirestore.instance.collection('all-events').doc(widget.eventId);
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  
  // Kullanıcı verisini çekiyoruz
  final userDoc = await userRef.get();
  List<dynamic> likedEvents = List.from(userDoc['likedEvents'] ?? []);  // likedEvents'ı liste olarak alıyoruz

  if (isLiked) {
    // Etkinliği beğenmediyse, likedEvents dizisine ekliyoruz
    if (!likedEvents.contains(widget.eventId)) {
      likedEvents.add(widget.eventId);
    }
    // Kullanıcıyı güncelliyoruz
    await userRef.update({
      'likedEvents': likedEvents,  // likedEvents dizisini güncelliyoruz
    });

    // Etkinlikten beğeni sayısını artırıyoruz
    await eventRef.update({
      'likesCounter': FieldValue.increment(1),
    });
  } else {
    // Etkinlik beğenildiyse, likedEvents dizisinden kaldırıyoruz
    likedEvents.remove(widget.eventId);
    // Kullanıcıyı güncelliyoruz
    await userRef.update({
      'likedEvents': likedEvents,  // likedEvents dizisini güncelliyoruz
    });

    // Etkinlikten beğeni sayısını düşürüyoruz
    await eventRef.update({
      'likesCounter': FieldValue.increment(-1),
    });
  }

  _controller.forward().then((_) => _controller.reverse());
}


  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: toggleLike,
      child: ScaleTransition(scale: _scaleAnimation,
      child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,color: isLiked ? Colors.red: Colors.grey,
      size: 32),),
    );
  }
  


  
}