import 'package:flutter/material.dart';
import 'package:yu_app/models/event.dart';
import 'package:yu_app/screens/event_details.dart';

class EventItem extends StatelessWidget {
  final Event event;

  const EventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () { 
               Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetails(
                                    event: event,
                                  )),
                        );              
            }, 
          child: Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    event.img,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  
                  Text(
                    event.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1), // Arka plan rengi
                        borderRadius:
                            BorderRadius.circular(15), // Köşeleri yuvarlak yapma
                      ),
                      child: Text(
                        event.clup,
                        style:Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                 
                  const SizedBox(
                    height: 30,
                  ),
                  
                  
                ],
               
              )),
        ),
      ),
    );
  }
}
