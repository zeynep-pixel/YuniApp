import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yu_app/models/event.dart';
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
      if (!userDoc.exists) {
        print("Kullanıcı belgesi bulunamadı.");
        return;
      }

      List<String> appliedEventIds = List<String>.from(userDoc.data()?['appliedEvents'] ?? []);
      print("Başvurulan etkinlik ID'leri: $appliedEventIds");

      if (appliedEventIds.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      List<Event> events = [];

      for (String eventId in appliedEventIds) {
        final eventDoc = await FirebaseFirestore.instance.collection('all-events').doc(eventId).get();

        if (eventDoc.exists) {
          try {
            Event event = Event.fromFirestore(eventDoc);
            events.add(event);
            print("Yüklendi: ${event.title}");
          } catch (e) {
            print("Hata: Event.fromFirestore başarısız. Event ID: $eventId, Hata: $e");
          }
        } else {
          print("Uyarı: Firestore'da etkinlik bulunamadı. Event ID: $eventId");
        }
      }

      setState(() {
        myEvents = events;
        isLoading = false;
      });

      print("Toplam yüklenen etkinlik sayısı: ${myEvents.length}");
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
              ? const Center(child: Text("Henüz etkinliğe başvurmadınız."))
              : Padding(
                  padding: const EdgeInsets.only(top: 20),
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
