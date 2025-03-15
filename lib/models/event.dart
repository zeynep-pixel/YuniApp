import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String firestoreId;
  final String clup;
  final String title;
  final String details;
  final String img;
  final String place;
  final bool isActive; // ✅ `String` yerine `bool` oldu!

  Event({
    required this.firestoreId,
    required this.clup,
    required this.title,
    required this.details,
    required this.img,
    required this.place,
    required this.isActive,
  });

  /// **Firestore belgesinden Event nesnesi oluşturma metodu**
  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Event(
      firestoreId: doc.id,
      clup: data['clup'] ?? '',
      title: data['title'] ?? '',
      details: data['details'] ?? '',
      img: data['img'] ?? '',
      place: data['place'] ?? '',
      isActive: data['isActive'] ?? false, // ✅ Firestore'dan `bool` alıyoruz!
    );
  }
}
