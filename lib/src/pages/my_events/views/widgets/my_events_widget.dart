import 'package:flutter/material.dart';
import '../../models/my_events_model.dart';

class MyEventsWidget extends StatelessWidget {
  const MyEventsWidget({
    super.key,
    required this.event,
  });

  final MyEventsModel event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blueAccent[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: (event.image!.isNotEmpty)
                ? ClipOval(child: Image.memory(event.image!))
                : const Icon(Icons.event, color: Colors.white),
            child: (event.image!.isNotEmpty)
                ? ClipOval(child: Image.memory(event.image!))
                : const Icon(Icons.event, color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(event.title,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.description,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.date,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.time,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.capacity.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.price.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
