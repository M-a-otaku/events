import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/events_controller.dart';
import '../../models/events_model.dart';

class EventsWidget extends GetView<EventsController> {
  const EventsWidget({
    super.key,
    required this.event,
  });

  final EventsModel event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blueAccent[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: (event.image != null && event.image!.isNotEmpty)
                ? ClipOval(child: Image.memory(base64Decode(event.image!)) , clipBehavior: Clip.hardEdge,)
                : const Icon(Icons.event, color: Colors.white),
            child: (event.image != null && event.image!.isNotEmpty)
                ? ClipOval(child: Image.memory(base64Decode(event.image!)))
                : const Icon(Icons.event, color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(event.title,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.description,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.date.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.time.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text('${event.participants} / ${event.capacity}',
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
