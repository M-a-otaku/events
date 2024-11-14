import 'dart:convert';

import 'package:events/src/pages/my_events/controllers/my_events_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/my_events_model.dart';

class MyEventsWidget extends GetView<MyEventsController> {
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
              Text(event.userId.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.description,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.date.year.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text(event.time.hour.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text('${event.participants} / ${event.capacity}',
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              Text("\$${event.price.toString()}",
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
