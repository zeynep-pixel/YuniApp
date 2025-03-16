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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('all-events').get();

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
  isActive: eventData['isActive'] ?? false,
  startDate: (eventData['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
  finishDate: (eventData['finishDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
);

        }).toList();

        setState(() {
          data = loadedItems.where((item) => item.isActive).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          data = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        data = [];
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
          ? const Center(child: CircularProgressIndicator())
          : data.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return EventItem(event: data[index]);
                        },
                      );
                    },
                  ),
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
