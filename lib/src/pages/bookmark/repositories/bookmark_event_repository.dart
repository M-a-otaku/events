import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../infrastructure/commons/url_repository.dart';
import '../../shared/local_storage_keys.dart';
import '../models/bookmark_user_dto.dart';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class BookmarkEventRepository {
  Future<Either<String, List<EventModel>>> getBookmarked({
    required String parameters,
  }) async {
    try {
      List<EventModel> bookmarkedEvents = [];
      final SharedPreferences preferences = await SharedPreferences.getInstance();

      final int userId = preferences.getInt(LocalKeys.userId) ?? -1;
      if (userId == -1) {
        return const Right([]);
      }

      String key = 'bookmarkedIds_$userId';
      List<String> bookmarkedIds = preferences.getStringList(key) ?? [];
      print(bookmarkedIds);

      final url = UrlRepository.getEventsByParameters(parameters: parameters);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body);

        // تطبیق داده‌های سرور با IDهای بوکمارک‌شده
        for (Map<String, dynamic> event in result) {
          final eventModel = EventModel.fromJson(event);

          // بررسی تطابق بین Bookmark و Event
          if (bookmarkedIds.contains(eventModel.id.toString())) {
            bookmarkedEvents.add(eventModel);
          }
        }

        return Right(bookmarkedEvents); // لیست رویدادهای بوکمارک‌شده
      } else {
        return Left("Failed to load events"); // خطا در دریافت داده‌ها
      }
    } catch (e) {
      return Left(e.toString()); // مدیریت استثناها
    }
  }

  Future<Either<String, bool>> editBookmarked({required BookmarkUserDto dto, required int userId,}) async {
    try {
      final url = UrlRepository.getUserById(userId: userId);
      final response = await http.patch(
        url,
        body: json.encode(dto.toJson()),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        return const Left(
          'Cant add this event to bookmarks',
        );
      }
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

}
