import 'events_model.dart';

class EventsUserDto {
  List<EventsModel> bookmark;

  EventsUserDto({
    required this.bookmark,
  });

  Map<String, dynamic> toJson() {
    return {
      "bookmark": bookmark,
    };
  }
}
