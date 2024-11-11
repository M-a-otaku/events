import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'dart:convert';
import '../../../infrastructure/commons/url_repository.dart';
import '../models/events_model.dart';
import '../models/events_user_dto.dart';
import '../models/user_model.dart';

class EventsRepository {
  Future<Either<String, List<EventsModel>>> getEvents() async {
    try {
      List<EventsModel> event = [];
      final url = UrlRepository.events;
      http.Response response = await http.get(url);
      List<dynamic> result = json.decode(response.body);

      for (Map<String, dynamic> events in result) {
        event.add((EventsModel.fromJson(json: events)));
      }
      return Right(event);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserModel>> getUserById({required int id}) async {
    try {
      final url = UrlRepository.userById(id: id);
      print(url);
      final http.Response response = await http.get(url);
      final Map<String, dynamic> result = json.decode(response.body);
      print(response.body);
      return Right(UserModel.fromJson(result));
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> editBookmarked({
    required EventsUserDto dto,
    required int userId,
  }) async {
    try {
      final url = UrlRepository.userById(id: userId);
      final response = await http.patch(
        url,
        body: json.encode(dto.toJson()),
        headers: {"Content-Type": "application/json"},
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
