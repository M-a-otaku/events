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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blueAccent[200],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Positioned image
          Positioned(
            right: 0,
            top: -20,
            child: (event.image != null && event.image!.isNotEmpty)
                ? ClipOval(
              child: Image.memory(
                base64Decode(event.image!),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(
              Icons.event,
              color: Colors.white,
              size: 80,
            ),
          ),
          // Text information
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.userId.toString(),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                '${event.date.year}-${event.date.month}-${event.date.day}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                '${event.time.hour}:${event.time.minute}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                '${event.participants ?? 0} / ${event.capacity}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "\$${event.price}",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
