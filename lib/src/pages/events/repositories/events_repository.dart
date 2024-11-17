import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../infrastructure/commons/url_repository.dart';
import '../../shared/local_storage_keys.dart';
import '../models/events_model.dart';
import '../models/events_user_dto.dart';

class EventsRepository {
  Future<Either<String, List<EventsModel>>> getEvents() async {
    try {
      List<EventsModel> events = [];
      final url = UrlRepository.events;
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      final int userId = preferences.getInt(LocalKeys.userId)??-1;
      if(userId == -1){
        return const Right([]);
      }
      http.Response response = await http.get(url);
      List<dynamic> result = json.decode(response.body);

      for (Map<String, dynamic> event in result) {
        events.add((EventsModel.fromJson(event)));
      }
      return Right(events);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> editBookmarked({
    required EventsUserDto dto,
    required int userId,
  }) async {
    try {
      final url = UrlRepository.getUserById(userId : userId);
      final response = await http.patch(
        url,
        body: json.encode(dto.toJson()),
        headers: {'Content-type': 'application/json',
          'Accept': 'application/json',},
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
