import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yu_app/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('tr', null); 

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
          primary: Color.fromARGB(255, 255, 200, 0),
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
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF4D35E)),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor:   Colors.deepPurple,
          foregroundColor: Colors.black,
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
        color:  Color(0xFFD7D7D7),
      ),
      child: child,
    );
  }
}

