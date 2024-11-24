import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'dart:convert';
import '../../../../generated/locales.g.dart';
import '../../../infrastructure/commons/url_repository.dart';
import '../models/events_model.dart';
import '../models/events_user_dto.dart';

class EventsRepository {

  Future<Either<String, List<EventsModel>>?> fetchEvents({
    required Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/events')
            .replace(queryParameters: queryParameters),
      );

      if (response.statusCode == 200) {
        final fetchedEvents = (jsonDecode(response.body) as List)
            .map((e) => EventsModel.fromJson(e))
            .toList();


        return Right(fetchedEvents);
      } } catch (e) {
      return Left("${LocaleKeys.error_error.tr}  ${e.toString()}");
    }
    return null;
  }


  Future<Either<String, bool>> editBookmarked({
    required EventsUserDto dto,
    required int userId,
  }) async {
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