import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yu_app/screens/auth_selection_screen.dart';
import 'package:yu_app/screens/events.dart';
import 'package:yu_app/screens/for_clubs/add_screen.dart';
import 'package:yu_app/screens/for_clubs/club_profiles.dart';
import 'package:yu_app/screens/for_users/my_events.dart';
import 'package:yu_app/screens/for_users/profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("YuniApp")),
      drawer: Drawer(
        backgroundColor:  Colors.deepPurple,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 80,
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: const Center(
                child: Text(
                  "Menü",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Kullanıcı giriş yapmamışsa "Giriş Yap" seçeneği
            if (user == null)
              ListTile(
                leading: const Icon(Icons.login, color: Color.fromARGB(255, 251, 250, 252)),
                title:  Text("Giriş Yap", style: TextStyle(color: Colors.white, fontSize: 18)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthSelectionScreen()),
                  );
                },
              )
            else ...[
  FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
    builder: (context, userSnapshot) {
      if (userSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Eğer `users` koleksiyonunda varsa, mevcut menüyü göster
      if (userSnapshot.hasData && userSnapshot.data!.exists) {
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text("Profil", style: TextStyle(color: Colors.white, fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event, color: Colors.white),
              title: const Text("Etkinliklerim", style: TextStyle(color: Colors.white, fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyEventsScreen()),
                );
              },
            ),
          ],
        );
      }

      // Eğer `users` koleksiyonunda yoksa, `clup` koleksiyonunu kontrol et
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('clups').doc(user.uid).get(),
        builder: (context, clubSnapshot) {
          if (clubSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (clubSnapshot.hasData && clubSnapshot.data!.exists) {
            return Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text("Profil", style: TextStyle(color: Colors.white, fontSize: 18)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ClubProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event, color: Colors.white),
                  title: const Text("Etkinlik Ekle", style: TextStyle(color: Colors.white, fontSize: 18)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddScreen()),
                    );
                  },
                ),
              ],
            );
          }

          
          return const SizedBox();
        },
      );
    },
  ),

  // Çıkış Yap seçeneği (Giriş yapan herkes için)
  ListTile(
    leading: const Icon(Icons.logout, color: Colors.white),
    title: const Text("Çıkış Yap", style: TextStyle(color: Colors.white, fontSize: 18)),
    onTap: () async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    },
  ),
],

          ],
        ),
      ),
      body: const Events(),
    );
  }
}

