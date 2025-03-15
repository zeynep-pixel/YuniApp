import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yu_app/main.dart';



class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // Firestore'dan kullanıcı verisini al
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        bool isUser = userDoc['user'] ?? false;

        if (isUser) {
          // Kulüp giriş yapabilir
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          );
        } else {
          // Yetkisiz giriş
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Yetkisiz giriş: Bu hesap kullanıcı olarak kayıtlı değil!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kullanıcı bulunamadı.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: $e')),
      );
    }
  }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 170), // Yukarı çekmek için boşluk eklendi
              const Text(
                'Üye Girişi',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Giriş Yap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





