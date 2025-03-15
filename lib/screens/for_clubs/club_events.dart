import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/screens/for_clubs/add_screen.dart';
import 'package:yu_app/widgets/event_item.dart';

class ClubEvents extends StatefulWidget {
  const ClubEvents({super.key});

  @override
  _ClubEventsState createState() => _ClubEventsState();
}

class _ClubEventsState extends State<ClubEvents> {
  List<Event> data = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
  try {
    // Firestore koleksiyonunu referans al
    CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('all-events');

    // Firestore'dan veriyi al
    QuerySnapshot snapshot = await eventsCollection.get();

    // Eğer veri varsa, Event modeline çevir
    if (snapshot.docs.isNotEmpty) {
      List<Event> loadedItems = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Event(
          firestoreId: doc.id,
          clup: data['clup'] ?? '',
          title: data['title'] ?? '',
          details: data['details'] ?? '',
          img: data['img'] ?? '',
          place: data['place'] ?? '',
          isActive: data['isActive'] ?? false,
        );
      }).toList();

      // Sadece aktif etkinlikleri al
      setState(() {
        data = loadedItems.where((item) => item.isActive == 'true').toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veri bulunamadı!')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veri alınırken hata oluştu: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Etkinlikler',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: data.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return EventItem(event: data[index]);
                    },
                  )
                : const Center(
                    child: Text(
                      'Henüz etkinlik bulunmamaktadır',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddScreen()),
                  );
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
