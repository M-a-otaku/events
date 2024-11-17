class EventsModel {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final int capacity;
  final int price;
  final String? image;
  final int? participants;
  final bool filled;

  EventsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.capacity,
    required this.price,
    this.image,
    this.participants,
    required this.filled,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.tryParse(json['date'])?.toLocal() ?? DateTime.now(),
      capacity: json['capacity'],
      price: json['price'],
      image: json['image'],
      participants: json['participants'],
      filled: json['filled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'capacity': capacity,
      'price': price,
      'image': image,
      'participants': participants,
      'filled': filled,
    };
  }
}
