
import 'package:flutter/material.dart';
import 'package:yu_app/screens/for_clubs/club_login_screen.dart';
import 'package:yu_app/screens/for_users/login_screen.dart';

class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
             Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8, // Genişliği ekranın %80'i kadar yapar
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10), // Yukarı çekmek için boşluk ekledim
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserLoginScreen()),
                  );
                },
                child: const Text('Üye Girişi'),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClubLoginScreen()),
                  );
                },
                child: const Text('Kulüp Girişi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
