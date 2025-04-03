
import 'package:flutter/material.dart';
import 'package:yu_app/screens/for_clubs/club_login_screen.dart';
import 'package:yu_app/screens/for_users/login_screen.dart';

class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.amber,
      body: Stack(
        children: [

          Center(
            child: SingleChildScrollView(
            child: FractionallySizedBox(
              widthFactor: 0.8, // Genişliği ekranın %80'i kadar yapar
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10), // Yukarı çekmek için boşluk ekledim
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                       minimumSize: Size(300, 20),

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
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
                      minimumSize: Size(300, 20),

                      
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
          ),
        Positioned(
          top: 80,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
        ),]
      ),
    );
  }
}
