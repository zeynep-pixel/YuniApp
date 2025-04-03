import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/widgets/only_name_event_item.dart';

class ProfileEventSection extends StatefulWidget {
  final String title; // Dışarıdan alınacak başlık
  final List<Event> events; // Dışarıdan alınacak etkinlikler

  const ProfileEventSection({super.key, required this.title, required this.events});

  @override
  _ProfileEventSectionState createState() => _ProfileEventSectionState();
}

class _ProfileEventSectionState extends State<ProfileEventSection> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 'widget' ile title ve events parametrelerine erişim sağlıyoruz
          Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          widget.events.isEmpty
              ? const Center(child: Text("Henüz etkinlik yok", style: TextStyle(color: Colors.grey)))
              : Column(
                  children: widget.events.map((event) => OnlyNameEventItem(event: event)).toList(),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
