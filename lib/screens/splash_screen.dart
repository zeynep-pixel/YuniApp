import 'package:flutter/material.dart';
import 'package:yu_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), 
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Yumuşak giriş çıkış efekti
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Arkaplan rengi deepPurple
      body: Center(
        child: ClipOval( // Yuvarlak bir logo
          child: FadeTransition(
            opacity: _animation,
            child: Image.asset(
              'assets/images/2.png', // **Logonu buraya ekle!**
              width: 200, // Boyutu ayarladım
              height: 200, // Boyutu ayarladım
            ),
          ),
        ),
      ),
    );
  }
}
