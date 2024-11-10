import 'package:flutter/material.dart';
import '../../models/events_model.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({
    super.key,
    required this.event,
    required this.onTap,
  });

  final EventsModel event;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: event.poster,
              child: Image.asset(
                event.poster,
                height: 115,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(event.title, style: const TextStyle(fontSize: 20)),
                Text(event.description, style: const TextStyle(fontSize: 20)),
                Text(event.date, style: const TextStyle(fontSize: 20)),
                Text(event.time, style: const TextStyle(fontSize: 20)),
                Text(event.capacity.toString(), style: const TextStyle(fontSize: 20)),
                Text(event.price.toString(), style: const TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
