
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEventDto {
  final int userId;
  final String title;
  final String description;
  final String time;
  final String date;
  final int capacity;
  final int price;
  int participants ;
  final String? image;
  bool filled ;

  AddEventDto({
    required this.userId,
    required this.filled,
    this.image,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.capacity,
    required this.participants,
    required this.price,
  });

Map<String, dynamic> toJson() => {
        "image": image,
        "userId": userId,
        "filled": filled,
        "participants": participants,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        "capacity": capacity,
        "price": price
      };
}
