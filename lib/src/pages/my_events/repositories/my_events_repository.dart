import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'dart:convert';
import '../../../infrastructure/commons/url_repository.dart';
import '../models/my_events_model.dart';

class MyEventsRepository {
  Future<Either<String, List<MyEventsModel>>?> getEvents() async {
    try {
      List<MyEventsModel> event = [];
      final url = UrlRepository.events;
      http.Response response = await http.get(url);
      List<dynamic> result = json.decode(response.body);

      for (Map<String, dynamic> events in result) {
        event.add((MyEventsModel.fromJson(json: events)));
      }
      return Right(event);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
