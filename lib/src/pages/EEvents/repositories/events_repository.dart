import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'dart:convert';
import '../../../infrastructure/commons/url_repository.dart';
import '../model/event_model.dart';

class EventRepository {
  Future<Either<String, List<EventModel>>?> getEvents() async {
    try {
      List<EventModel> events = [];
      final url = UrlRepository.events;
      http.Response response = await http.get(url);
      List<dynamic> result = json.decode(response.body);

      for (Map<String, dynamic> event in result) {
        events.add(EventModel.fromJson(json: event));
      }
      return Right(events);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
