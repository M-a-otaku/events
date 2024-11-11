import 'dart:typed_data';
import 'dart:convert';

class MyEventsModel {
  final int id;
  final int creatorId;
  final String title;
  final String description;
  final String date;
  final String time;
  final int capacity;
  final double price;
  int? participants = 0;
  String? imageBase = '';
  Uint8List? image;
  bool filled;

  MyEventsModel({
    required this.id,
    required this.creatorId,
    this.participants,
    this.imageBase,
    required this.title,
    required this.filled,
    required this.description,
    required this.date,
    required this.time,
    required this.capacity,
    required this.price,
  }) {
    image = base64Decode(imageBase!);
  }

  factory MyEventsModel.fromJson({required Map<String, dynamic> json}) {
    return MyEventsModel(
      imageBase: json["imageBase"],
      title: json["title"],
      description: json["description"],
      date: json["date"],
      time: json["time"],
      capacity: json["capacity"],
      price: json["price"],
      id: json["id"],
      participants: json["participants"],
      creatorId: json["creatorId"],
      filled: json["filled"],
    );
  }

  @override
  String toString() {
    return "$imageBase, $title, $description, $date, $time, $capacity, $price";
  }
}
