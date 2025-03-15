import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/widgets/event_item.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<Event> data = [];
  bool isLoading = true; // Başlangıçta yükleme aktif

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('all-events');

      QuerySnapshot snapshot = await eventsCollection.get();

      if (snapshot.docs.isNotEmpty) {
        List<Event> loadedItems = snapshot.docs.map((doc) {
          final eventData = doc.data() as Map<String, dynamic>;

          return Event(
  firestoreId: doc.id,
  clup: eventData['clup'] ?? '',
  title: eventData['title'] ?? '',
  details: eventData['details'] ?? '',
  img: eventData['img'] ?? '',
  place: eventData['place'] ?? '',
  isActive: eventData['isActive'] ?? false, // ✅ `String` yerine `bool` olarak al
);
        }).toList();

        setState(() {
          data = loadedItems.where((item) => item.isActive == true).toList();
          isLoading = false; // Veri alındı, yükleme tamamlandı
        });
      } else {
        setState(() {
          data = [];
          isLoading = false; // Veri bulunamadı ama yükleme tamamlandı
        });
      }
    } catch (e) {
      setState(() {
        data = []; // Hata olursa veri listesi boş olmalı
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri alınırken hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Yükleme göstergesi
            )
          : data.isNotEmpty
              ? GridView.builder(
                  padding: const EdgeInsets.all(5),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
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
    );
  }
}

