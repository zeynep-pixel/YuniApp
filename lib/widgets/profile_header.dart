import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yu_app/models/event.dart';

class ProfileHeader extends StatefulWidget{
  const ProfileHeader({super.key});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();


  
}

class _ProfileHeaderState extends State<ProfileHeader>{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = "";
  String surname = "";
  String profileImage = "";
  List<Event> upcomingEvents = [];
  List<Event> pastEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (!userDoc.exists) return;

      setState(() {
        name = userDoc["name"] ?? "";
        surname = userDoc["surname"] ?? "";
        profileImage = userDoc["profileImage"] ?? "";
      });

      List<String> appliedEventIds = List<String>.from(userDoc.data()?['appliedEvents'] ?? []);

      if (appliedEventIds.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      List<Event> events = [];
      for (String eventId in appliedEventIds) {
        final eventDoc = await _firestore.collection('all-events').doc(eventId).get();
        if (eventDoc.exists) {
          events.add(await Event.fromFirestore(eventDoc));
        }
      }

      DateTime now = DateTime.now().toUtc(); 

upcomingEvents = events.where((e) => e.startDate.isAfter(now)).toList();
pastEvents = events.where((e) => e.startDate.isBefore(now)).toList();


      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("Profil verileri getirilirken hata oluştu: $e");
      setState(() => isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
 
    return Container(
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.only(top: 100, bottom: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: profileImage.isNotEmpty
                ? NetworkImage(profileImage)
                : const AssetImage("assets/images/default_profile.png") as ImageProvider,
          ),
          const SizedBox(height: 10),
          Text(
            "$name $surname",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  

  }

  
}