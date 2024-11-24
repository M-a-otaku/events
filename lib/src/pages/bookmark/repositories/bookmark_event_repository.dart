import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../generated/locales.g.dart';
import '../../../infrastructure/commons/url_repository.dart';
import '../../shared/local_storage_keys.dart';
import '../models/bookmark_user_dto.dart';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class BookmarkEventRepository {
  Future<Either<String, List<EventModel>>> getBookmarked({
    required Map<String, dynamic> queryParameters ,
  }) async {
    try {
      List<EventModel> bookmarkedEvents = [];

      final SharedPreferences preferences = await SharedPreferences.getInstance();
      final int userId = preferences.getInt(LocalStorageKeys.userId) ?? -1;
      List<String> bookmarkedIds =
          preferences.getStringList('bookmarkedIds_$userId') ?? [];

      final response = await http.get(
        Uri.parse('http://localhost:3000/events')
            .replace(queryParameters: queryParameters),
      );

      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body);

        for (Map<String, dynamic> event in result) {
          final eventModel = EventModel.fromJson(event);

          if (bookmarkedIds.contains(eventModel.id.toString())) {
            bookmarkedEvents.add(eventModel);
          }
        }

        return Right(bookmarkedEvents);
      } else {
        return  Left(LocaleKeys.error_error.tr);
      }
    } catch (e) {
      return Left("${LocaleKeys.error_error.tr}  ${e.toString()}");
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
        return  Left(
          LocaleKeys.error_repository_add_bookmark.tr,
        );
      }
      return const Right(true);
    } catch (e) {
      return Left("${LocaleKeys.error_error.tr}  ${e.toString()}");
    }
  }

}
