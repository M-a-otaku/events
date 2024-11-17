
class EditEventDto {
  final int userId;
  final String title;
  final String description;
  // final DateTime time;
  final DateTime date;
  final int capacity;
  final int price;
  int participants;
  final String? image;
  bool filled;

  EditEventDto({
    required this.userId,
    required this.filled,
    this.image,
    required this.title,
    required this.description,
    required this.date,
    // required this.time,
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
        "date": date.toUtc().toIso8601String(),
        // "time": time.toUtc().toIso8601String(),
        "capacity": capacity,
        "price": price
      };
}
