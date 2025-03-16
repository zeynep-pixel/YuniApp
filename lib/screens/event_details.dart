import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yu_app/models/event.dart';
import 'package:intl/intl.dart';
import 'package:yu_app/widgets/build_info_card.dart'; 

class EventDetails extends ConsumerStatefulWidget {
  final Event event;

  const EventDetails({super.key, required this.event});

  @override
  ConsumerState<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends ConsumerState<EventDetails> {
  bool? isApplied;

  @override
  void initState() {
    super.initState();
    checkIfApplied();
  }

  Future<void> checkIfApplied() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isApplied = false);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final appliedEvents = prefs.getStringList('appliedEvents') ?? [];
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await userRef.get();
    final firestoreEvents = snapshot.exists
        ? List<String>.from(snapshot.data()?['appliedEvents'] ?? [])
        : [];

    setState(() {
      isApplied = appliedEvents.contains(widget.event.firestoreId.toString()) ||
                  firestoreEvents.contains(widget.event.firestoreId.toString());
    });
  }

  Future<void> applyToEvent() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final appliedEvents = prefs.getStringList('appliedEvents') ?? [];

    if (!appliedEvents.contains(widget.event.firestoreId.toString())) {
      appliedEvents.add(widget.event.firestoreId.toString());
      await prefs.setStringList('appliedEvents', appliedEvents);

      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.set({
        'appliedEvents': FieldValue.arrayUnion([widget.event.firestoreId.toString()])
      }, SetOptions(merge: true));

      setState(() => isApplied = true);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başvurunuz alındı!')),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  final dateFormat = DateFormat('dd MMMM yyyy - HH:mm', 'tr'); // 📌 Tarihi düzgün formatlamak için

  return Scaffold(
    backgroundColor: Colors.grey[200],
    body: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // 🔥 HERO Animasyonu ile görsel
              Hero(
                tag: widget.event.firestoreId,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  child: Image.network(
                    widget.event.img,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔥 Etkinlik Başlığı
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.event.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

            
             

              // 🔥 Açıklama Bölümü
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.event.details
                      .replaceAll(r'\n', '\n')
                      .split('\n')
                      .map((line) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              line.trim(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                              textAlign: TextAlign.justify,
                            ),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 20),

               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                   BuildInfoCard(
  icon: Icons.event,
  title: "Başlangıç",
  value: dateFormat.format(widget.event.startDate ),
),
BuildInfoCard(
  icon: Icons.event_available,
  title: "Bitiş",
  value: dateFormat.format(widget.event.finishDate),
),
BuildInfoCard(
  icon: Icons.location_on,
  title: "Mekan" ,
  value: widget.event.place,
),
BuildInfoCard(
  icon: Icons.group,
  title: "Kulüp" ,
  value: widget.event.clup,
),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🔥 Başvuru Butonu
              if (user != null)
                isApplied == null
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(

                        onPressed: isApplied! ? null : applyToEvent,
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: Text(
                          isApplied! ? 'Başvuru Tamamlandı' : 'Başvur',
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isApplied! ? Colors.grey : Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          
                        ),
                      ),

              const SizedBox(height: 40),
            ],
          ),
        ),

        // 🔥 Geri Butonu
       Positioned(
  top: 40,
  left: 20,
  child: GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      width: 40, // 📌 Boyutu sabitledik
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), // 📌 Şeffaf gri arka plan
        shape: BoxShape.circle, // 📌 Yuvarlak şekil
      ),
      child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
    ),
  ),
),

      ],
    ),
  );
}


}