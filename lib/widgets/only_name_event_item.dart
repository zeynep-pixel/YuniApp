import 'package:flutter/material.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/screens/event_details.dart';

class OnlyNameEventItem extends StatelessWidget {
  final Event event;

  const OnlyNameEventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetails(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12), // Hafif boşluk
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), 
        decoration: BoxDecoration(
          color: Color(0xFFF4D35E), // Beyaz arka plan
          borderRadius: BorderRadius.circular(10),
          // Mor çerçeve
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            event.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Yazı rengi mor
                ),
          ),
        ),
      ),
    );
  }
}
