import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/widgets/only_name_event_item.dart';

class ClubProfileScreen extends StatefulWidget {
  const ClubProfileScreen({super.key});

  @override
  _ClubProfileScreenState createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String clubName = "";
  String img = "";
  List<Event> publishedEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClubData();
  }

  Future<void> fetchClubData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final clubDoc = await _firestore.collection("clups").doc(user.uid).get();
      if (!clubDoc.exists) return;

      setState(() {
        clubName = clubDoc["name"] ?? "";
        img = clubDoc["img"] ?? "https://www.google.com/imgres?q=%20profile&imgurl=https%3A%2F%2Fimg.freepik.com%2Fpremium-vector%2Favatar-profile-icon-flat-style-female-user-profile-vector-illustration-isolated-background-women-profile-sign-business-concept_157943-38866.jpg&imgrefurl=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fprofile&docid=WIYPytbMl_8XfM&tbnid=HLImyoW3EMuuBM&vet=12ahUKEwiH4-2VnI-MAxWBBNsEHSliClsQM3oFCIABEAA..i&w=626&h=626&hcb=2&ved=2ahUKEwiH4-2VnI-MAxWBBNsEHSliClsQM3oFCIABEAA";
        print(img);

      });

      List<String> publishedEventIds = List<String>.from(clubDoc.data()?['publishedEvents'] ?? []);

      if (publishedEventIds.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      List<Event> events = [];
      for (String eventId in publishedEventIds) {
        final eventDoc = await _firestore.collection('all-events').doc(eventId).get();
        if (eventDoc.exists) {
          events.add(await Event.fromFirestore(eventDoc));
        }
      }

      setState(() {
        publishedEvents = events;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Kulüp profili verileri getirilirken hata oluştu: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kulüp Profili")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 20),
                  _buildEventSection("Yayınlanan Etkinlikler", publishedEvents),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.only(top: 100, bottom: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:  NetworkImage(img), // Kulüp simgesi
          ),
          const SizedBox(height: 10),
          Text(
            clubName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
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
