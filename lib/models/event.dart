import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String firestoreId;
  final String clup;
  final String title;
  final String details;
  final String img;
  final String place;
  final bool isActive;
  final DateTime startDate; // ✅ DateTime türüne çevirdik
  final DateTime finishDate;

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
  });

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  
  return Event(
    firestoreId: doc.id,
    clup: data['clup'] ?? '',
    title: data['title'] ?? '',
    details: data['details'] ?? '',
    img: data['img'] ?? '',
    place: data['place'] ?? '',
    isActive: data['isActive'] ?? false,
    startDate: data['startDate'] != null
        ? (data['startDate'] as Timestamp).toDate().toLocal() // ✅ UTC yerine yerel saat
        : DateTime.now(), // ❌ Hata varsa şimdiki tarihi ata (Geçici çözüm)
    finishDate: data['finishDate'] != null
        ? (data['finishDate'] as Timestamp).toDate().toLocal() // ✅ UTC yerine yerel saat
        : DateTime.now(), // ❌ Hata varsa şimdiki tarihi ata (Geçici çözüm)
  );
}


}
