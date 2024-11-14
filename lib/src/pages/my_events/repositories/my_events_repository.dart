import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../infrastructure/commons/url_repository.dart';
import '../../shared/local_storage_keys.dart';
import '../models/my_events_model.dart';

class MyEventsRepository {
  Future<Either<String, List<MyEventsModel>>> getMyEvents(
      {required int userId}) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final int userId = preferences.getInt(LocalKeys.userId) ?? -1;
      print(userId.toString());
      List<MyEventsModel> events = [];
      if (userId == -1) {
        return const Right([]);
      }
      final url = UrlRepository.myEvents(userId);
      http.Response response = await http.get(url);
      List<dynamic> result = json.decode(response.body);
      print(url);

      for (Map<String, dynamic> event in result) {
        if (event["userId"] == userId) {
          events.add((MyEventsModel.fromJson(json: event)));
        }
      }
      return Right(events);
    } catch (e) {
      return Left(e.toString());
    }
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
}
