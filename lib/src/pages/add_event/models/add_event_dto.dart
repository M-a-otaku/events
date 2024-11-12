import 'dart:typed_data';
import 'dart:convert';

class AddEventDto {
  final int creatorId;
  final String title;
  final String description;
  final String date;
  final String time;
  final int capacity;
  final int price;
  int? participants = 0;
  String? imageBase = '';
  bool filled = false;

  AddEventDto({
    required this.creatorId,
    this.imageBase,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.capacity,
    required this.price,
  });

Map<String, dynamic> toJson() => {
        "imageBase": imageBase,
        "participants": participants,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        "capacity": capacity,
        "price": price
      };
}
