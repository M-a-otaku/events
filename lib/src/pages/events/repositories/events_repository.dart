import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'dart:convert';
import '../../../infrastructure/commons/url_repository.dart';
import '../models/events_model.dart';

class EventsRepository {
  Future<Either<String, List<EventsModel>>?> getEvents() async {
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
}
