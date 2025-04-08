import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String firestoreId;
  final String clup; 
  final String title;
  final String details;
  final String img;
  final String place;
  final bool isActive;
  final DateTime startDate;
  final DateTime finishDate;
  final List<String> categories; 
  final int likesCounter;

  Event({
    required this.firestoreId,
    required this.clup,
    required this.title,
    required this.details,
    required this.img,
    required this.place,
    required this.isActive,
    required this.startDate,
    required this.finishDate,
    required this.categories, 
    required this.likesCounter,
  });

  static Future<Event> fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) async {
    final data = doc.data();

    if (data == null) {
      throw Exception("❌ Firestore'dan veri çekilemedi! (Döküman ID: ${doc.id})");
    }

   
    String clubName = "Bilinmeyen Kulüp";
    if (data['clup'] != null && data['clup'].toString().isNotEmpty) {
      final clubDoc = await FirebaseFirestore.instance.collection('clups').doc(data['clup']).get();
      if (clubDoc.exists) {
        clubName = clubDoc.data()?['name'] ?? clubName;
      }
    }

   
  
    return Event(
      firestoreId: doc.id,
      clup: clubName, 
      title: data['title'] ?? '',
      details: data['details'] ?? '',
      img: data['img'] ?? '',
      place: data['place'] ?? '',
      isActive: data['isActive'] ?? false,
      startDate: (data['startdate'] is Timestamp)
          ? (data['startdate'] as Timestamp).toDate().toLocal()
          : DateTime.now(),
      finishDate: (data['finishdate'] is Timestamp)
          ? (data['finishdate'] as Timestamp).toDate().toLocal()
          : DateTime.now(),
      categories: List<String>.from(data['categories'] ?? []), 
      likesCounter: data['likesCounter'] ?? 0,
    );
  }
}

