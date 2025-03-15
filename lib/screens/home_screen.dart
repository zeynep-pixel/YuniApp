import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yu_app/screens/auth_selection_screen.dart';
import 'package:yu_app/screens/events.dart';
import 'package:yu_app/screens/for_users/my_events.dart';

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
                title: const Text("Giriş Yap", style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthSelectionScreen()),
                  );
                },
              )
            else ...[
              // Kullanıcı giriş yapmışsa ancak kulüp değilse "Etkinliklerim" seçeneği
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(), // Yükleme göstergesi eklendi
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox();
                  }

                  final userData = snapshot.data!.data() as Map<String, dynamic>?;
                  final isClub = userData?['isClub'] ?? false;

                  if (!isClub) {
                    return ListTile(
                      leading: const Icon(Icons.event, color: Colors.deepPurple),
                      title: const Text("Etkinliklerim"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyEventsScreen()),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),

              // Çıkış Yap seçeneği (Giriş yapan herkes için)
              ListTile(
                leading: const Icon(Icons.logout, color: Color.fromARGB(255, 229, 133, 126)),
                title: const Text("Çıkış Yap"),
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

