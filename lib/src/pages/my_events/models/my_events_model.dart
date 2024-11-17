class MyEventsModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final DateTime date;
  // final DateTime time;
  final int capacity;
  final int price;
  int? participants = 0;
  final String? image;
  bool filled;

  MyEventsModel({
    required this.id,
    required this.userId,
    required this.image,
    this.participants,
    required this.title,
    required this.filled,
    required this.description,
    required this.date,
    required this.capacity,
    required this.price,
  });

  factory MyEventsModel.fromJson({required Map<String, dynamic> json}) {
    return MyEventsModel(
      image: json["image"],
      title: json["title"],
      description: json["description"],
      date: DateTime.tryParse(json['date'])?.toLocal() ?? DateTime.now(),
      capacity: json["capacity"],
      price: json["price"],
      id: json["id"],
      participants: json["participants"],
      userId: json["userId"],
      filled: json["filled"],
    );
  }

  MyEventsModel copyWith({
    String? image,
    String? title,
    String? description,
    DateTime? date,
    int? capacity,
    int? price,
    int? id,
    int? userId,
    int? participants,
    bool? filled,
  }) =>
      MyEventsModel(
        image: image ?? this.image,
        title: title ?? this.title,
        description: description ?? this.description,
        capacity: capacity ?? this.capacity,
        price: price ?? this.price,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        participants: participants ?? this.participants,
        filled: filled ?? this.filled,
        date: date ?? this.date,
      );

  @override
  String toString() {
    return "$image, $title, $description, $date , $filled, $capacity, $price";
  }
}
