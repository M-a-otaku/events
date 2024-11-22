class EventsModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final DateTime date;
  final int capacity;
  final int price;
  final String? image;
  final int? participants;
  final bool filled;
  final bool isBookmark;

  EventsModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    required this.capacity,
    required this.price,
    required this.isBookmark,
    this.image,
    this.participants,
    required this.filled,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      date: DateTime.tryParse(json['date'])?.toLocal() ?? DateTime.now(),
      capacity: json['capacity'],
      price: json['price'],
      image: json['image'],
      participants: json['participants'],
      filled: json['filled'],
      isBookmark: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
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
   return "$title , $id , $description , $date , $userId , $capacity , $price , $image , $participants";
  }
}
