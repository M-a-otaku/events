class MyEventsModel {
  final String poster;
  final String title;
  final String description;
  final String date;
  final String time;
  final int capacity;
  final int price;

  MyEventsModel({
    required this.poster,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.capacity,
    required this.price,
  });

  factory MyEventsModel.fromJson({required Map<String, dynamic> json}){
    return MyEventsModel(
      poster: json["poster"],
      title: json["title"],
      description: json["description"],
      date: json["date"],
      time: json["time"],
      capacity: json["capacity"],
      price: json["price"],
    );
  }
  @override
  String toString(){
    return "$poster, $title, $description, $date, $time, $capacity, $price";
  }
}