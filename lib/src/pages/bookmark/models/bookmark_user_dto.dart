class BookmarkUserDto {
  List bookmark;

  BookmarkUserDto({
    required this.bookmark,
  });

  Map<String, dynamic> toJson() {
    return {
      "bookmark": bookmark,
    };
  }
}
