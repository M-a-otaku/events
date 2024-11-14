class AddEventsModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final DateTime date;
  final DateTime time;
  final int capacity;
  final double price;
  int? participants = 0;
  final String? image;
  bool filled;

  AddEventsModel({
    required this.id,
    required this.userId,
    required this.image,
    this.participants,
    required this.title,
    required this.filled,
    required this.description,
    required this.time,
    required this.date,
    required this.capacity,
    required this.price,
  });

  factory AddEventsModel.fromJson({required Map<String, dynamic> json}) {
    return AddEventsModel(
      image: json["image"],
      title: json["title"],
      description: json["description"],
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
      time:  DateTime.tryParse(json['time']) ?? DateTime.now(),
      capacity: json["capacity"],
      price: json["price"],
      id: json["id"],
      participants: json["participants"],
      userId: json["userId"],
      filled: json["filled"],
    );
  }

  @override
  String toString() {
    return "$image, $title, $description, $date ,$time, $filled, $capacity, $price";
  }
}
