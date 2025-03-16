import 'package:flutter/material.dart';

class BuildInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const BuildInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 113, 73, 183), // 📌 Arka plan rengi deepPurple
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white), // 📌 İkon rengi beyaz
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // 📌 Başlık rengi beyaz
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.white70), // 📌 Açıklama rengi beyazın tonu
        ),
      ),
    );
  }
}
