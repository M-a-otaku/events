class EventModel {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final int capacity;
  final double price;
  final String? image;
  final int? participants;
  final bool filled;

  EventModel({
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

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      capacity: json['capacity'],
      price: json['price'].toDouble(),
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

  @override
  String toString() {
    return "title : $title ,id : $id , $description , $date , $capacity , $price , $image , $participants";
  }
}
