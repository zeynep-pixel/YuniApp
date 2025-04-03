import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/screens/event_details.dart';
import 'package:yu_app/widgets/category_selector.dart';
import 'package:yu_app/widgets/event_item.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<Event> pastEvents = [];
  List<Event> latesEvents = []; 
  List<Event> data = []; // Tüm etkinlikler (normal liste)
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
      List<Event> loadedItems = await Future.wait(snapshot.docs.map((doc) async {
        final eventData = doc.data() as Map<String, dynamic>? ?? {};

        // Kulüp adını çek
        String clubName = "Bilinmeyen Kulüp";
        if (eventData['clup'] != null && eventData['clup'].toString().isNotEmpty) {
          final clubDoc = await FirebaseFirestore.instance.collection('clups').doc(eventData['clup']).get();
          if (clubDoc.exists) {
            clubName = clubDoc.data()?['name'] ?? clubName;
          }
        }

        return Event(
          firestoreId: doc.id,
          clup: clubName,
          title: eventData['title'] ?? '',
          details: eventData['details'] ?? '',
          img: eventData['img'] ?? '',
          place: eventData['place'] ?? '',
          isActive: eventData['isActive'] ?? false,
          startDate: eventData['startdate'] is Timestamp
              ? (eventData['startdate'] as Timestamp).toDate().toLocal()
              : DateTime.now(),
          finishDate: eventData['finishdate'] is Timestamp
              ? (eventData['finishdate'] as Timestamp).toDate().toLocal()
              : DateTime.now(),
        );
      }).toList());

      DateTime now = DateTime.now();
      DateTime sevenDaysLater = now.add(const Duration(days: 7));

      setState(() {
        latesEvents = loadedItems
            .where((event) =>
                event.startDate.isAfter(now) && event.startDate.isBefore(sevenDaysLater))
            .toList();
        data = loadedItems;
        pastEvents = loadedItems.where((event) => event.startDate.isBefore(now)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        pastEvents = [];
        latesEvents = [];
        data = [];
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      pastEvents = [];
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  CategorySelector(),
                 // öne çıkanlar
                  if (latesEvents.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                        
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: latesEvents.length,
                            itemBuilder: (context, index) {
                              final event = latesEvents[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetails(event: event),
                                    ),
                                  );
                                },
                                child: Card(
                                  
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 5,
                                  child: ClipRRect(
                                  
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          event.img,
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.6),
                                                Colors.transparent,
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: Text(
                                            event.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    
                  ],

                  // Tüm etkinlikler listesi (Mevcut çalışan kod)
                  if (data.isNotEmpty) ...[
                   
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                    ),
                  ],

                  // Geçmiş etkinlikler listesi (Kartlar halinde)
                  if (pastEvents.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            "Geçmiş Etkinlikler",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pastEvents.length,
                            itemBuilder: (context, index) {
                              final event = pastEvents[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetails(event: event),
                                    ),
                                  );
                                },
                                child: Card(
                                  
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 5,
                                  child: ClipRRect(
                                  
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          event.img,
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: double.infinity,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.6),
                                                Colors.transparent,
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: Text(
                                            event.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
