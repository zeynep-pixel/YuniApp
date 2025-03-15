import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/widgets/event_item.dart';
import 'package:yu_app/widgets/only_name_event_item.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  List<Event> myEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMyEvents();
  }

  Future<void> fetchMyEvents() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return;

    List<String> appliedEventIds = List<String>.from(userDoc.data()?['appliedEvents'] ?? []);
    print(appliedEventIds);

    if (appliedEventIds.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    // Başvurulan etkinlikleri Firestore'dan getir
    List<Event> events = [];
    for (String eventId in appliedEventIds) {
      final eventDoc = await FirebaseFirestore.instance.collection('all-events').doc(eventId).get();
      print("Event Document ID: ${eventDoc.id}");
print("Event Data: ${eventDoc.data()}");

      if (eventDoc.exists) {
        events.add(Event.fromFirestore(eventDoc));
      }
    }
  


    setState(() {
      myEvents = events;
      isLoading = false;
      
    });
    
  } catch (e) {
    debugPrint("Etkinlikler getirilirken hata oluştu: $e");
    setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Etkinliklerim")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : myEvents.isEmpty
              ? const Center(child: Text("Henüz bir etkinliğe başvurmadınız."))
              :  Padding(
            padding: const EdgeInsets.only(top: 20), // Üstten boşluk ekledik
            child: ListView.builder(
              itemCount: myEvents.length,
              itemBuilder: (context, index) {
                return OnlyNameEventItem(event: myEvents[index]);
              },
            ),
          ),
    );
  }
}
