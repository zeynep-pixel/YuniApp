import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yu_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
          secondary: const Color(0xFFFFA726), // Turuncu tonu
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          background: Colors.transparent, // Arka plan şeffaf
          onBackground: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent, // **Burada siyah olmasını engelledik**
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: const GradientBackground(child: HomeScreen()),
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
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 227, 174, 235), Color.fromARGB(255, 162, 172, 241)], // Mor ve Turuncu Geçiş
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
