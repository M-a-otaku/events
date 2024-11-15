import 'package:events/src/pages/EEvents/controller/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarItems extends GetView<EventController> {
  const CarItems({
    required this.name,
    required this.value,
    this.textColor = Colors.white,
    super.key,
  });
  final String name, value;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
