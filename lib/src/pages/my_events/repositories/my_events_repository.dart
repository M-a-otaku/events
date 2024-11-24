import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'dart:convert';
import '../../../infrastructure/commons/url_repository.dart';
import '../models/events_user_dto.dart';
import '../models/my_events_model.dart';

class MyEventsRepository {
  Future<Either<String, List<MyEventsModel>>?> fetchMyEvents({
    required Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/events')
            .replace(queryParameters: queryParameters),
      );

      if (response.statusCode == 200) {
        final fetchedEvents = (jsonDecode(response.body) as List)
            .map((e) => MyEventsModel.fromJson(json: e))
            .toList();


        return Right(fetchedEvents);
      } } catch (e) {
      print('Error: $e');
      return Left(e.toString());
    }
    return null;
  }

  Future<Either<String, bool>> deleteEventById({required int eventId}) async {
    try {
      final url = UrlRepository.deleteEventById(eventId: eventId);
      final http.Response response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        return const Left("can't delete this event");
      }
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
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
