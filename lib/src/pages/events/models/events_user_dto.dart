class EventsUserDto {
  List bookmark;

  EventsUserDto({
    required this.bookmark,
  });

  Map<String, dynamic> toJson() {
    return {
      "bookmarked": bookmark,
    };
  }
}
