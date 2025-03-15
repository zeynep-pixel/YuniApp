import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yu_app/main.dart';
import 'package:yu_app/models/event.dart';

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

    return Scaffold(
       backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text("YuniApp"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: widget.event.firestoreId,
              child: Image.network(
                widget.event.img,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.event.title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
             Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.event.details
                  .replaceAll(r'\n', '\n')
                  .split('\n')
                  .map((line) => Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          line.trim(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.justify,
                        ),
                      ))
                  .toList(),
            ),
          ),
            const SizedBox(height: 20),
            if (user != null)
              isApplied == null
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: isApplied! ? null : applyToEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isApplied! ? Colors.grey : Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text(
                        isApplied! ? 'Başvuru Tamamlandı' : 'Başvur',
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}