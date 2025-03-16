import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yu_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('tr', null); // 📌 Türkçe tarih desteği

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          secondary: const Color(0xFFFFA726),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          background: Colors.transparent,
          onBackground: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: const SplashScreen(),
      builder: (context, child) {
        return GradientBackground(child: child ?? const SizedBox());
      },
    );
  }
}

// **Gradient Arka Plan Widget'ı**
class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 213, 213, 213),
      ),
      child: child,
    );
  }
}

// **🔥 Splash Screen - Açılış Ekranı**
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
    
    // **Animasyon Ayarları**
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 saniyede fade in
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Yumuşak giriş çıkış efekti
    );

    _controller.forward();

    // **3 saniye sonra HomeScreen'e yönlendir**
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
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/images/2.png', // **Logonu buraya ekle!**
            width:400,
            height: 400,
          ),
        ),
      ),
    );
  }
}
