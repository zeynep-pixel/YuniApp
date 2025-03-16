import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yu_app/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('tr', null); // 📌 Türkçe tarih desteği ekledik

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
         textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.deepPurple),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black),
    titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    bodySmall: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
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
        color: Color.fromARGB(255, 213, 213, 213)
      ),
      child: child,
    );
  }
}
