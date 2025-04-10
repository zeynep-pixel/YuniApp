import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/widgets/only_name_event_item.dart';
import 'package:yu_app/widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = "";
  String surname = "";
  String profileImage = "";
  List<Event> upcomingEvents = [];
  List<Event> pastEvents = [];
  List<Event> savedEvents = [];
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
      
      List<String> appliedEventIds = List<String>.from(userDoc.data()?['appliedEvents'] ?? []);
      List<String> savedEventIds = List<String>.from(userDoc.data()?['savedEvents'] ?? []);
      
      List<Event> _savedEvents = [];
      for (String eventId in savedEventIds) {
        final eventDoc = await _firestore.collection('all-events').doc(eventId).get();
        if (eventDoc.exists) {
          _savedEvents.add(await Event.fromFirestore(eventDoc));
        }
      }

    

      setState(() {
        name = userDoc["name"] ?? "";
        surname = userDoc["surname"] ?? "";
        profileImage = userDoc["profileImage"] ?? "";
        savedEvents =_savedEvents;
      });

      

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
    return Stack(
      children: [Scaffold(
        
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileHeader(),
                    const SizedBox(height: 20),
                    _buildEventSection("Başvurduğum Etkinlikler", upcomingEvents),
                    _buildEventSection("Katıldığım Etkinlikler", pastEvents),
                    _buildEventSection("Kaydettiğim Etkinlikler", savedEvents)
                  ],
                ),
              ),
      ),
      Positioned(
          top: 80,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
        ),

      ]
    );
  }



  Widget _buildEventSection(String title, List<Event> events) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          events.isEmpty
              ? const Center(child: Text("Henüz etkinlik yok", style: TextStyle(color: Colors.grey)))
              : Column(
                  children: events.map((event) => OnlyNameEventItem(event: event)).toList(),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}