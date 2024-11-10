class AddEventDto {
  final String? poster;
  final String title;
  final String description;
  final String date;
  final String time;
  final int capacity;
  final int price;

  AddEventDto({
    required this.poster,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.capacity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        "poster": poster,
        "title": title,
        "description": description,
        "date": date,
        "time": time,
        "capacity": capacity,
        "price": price
      };
}
