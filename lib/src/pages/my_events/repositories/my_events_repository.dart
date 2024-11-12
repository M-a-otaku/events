import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import 'dart:convert';
import '../../../infrastructure/commons/url_repository.dart';
import '../models/my_events_model.dart';

class MyEventsRepository {
  Future<Either<String, List<MyEventsModel>>?> getMyEvents({required int creatorId}) async {
    try {
      List<MyEventsModel> events = [];
      print("Suiiiiiiiiiiii");
      final url = UrlRepository.events;
      http.Response response = await http.get(url);
      List<dynamic> result = json.decode(response.body);

      for (Map<String, dynamic> event in result) {
        events.add((MyEventsModel.fromJson(json: event)));
      }
      return Right(events);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Future<Either<String, bool>> deleteEventById({required int eventId}) async {
  //   try {
  //     final url = UrlRepository.deleteEventById(eventId: eventId);
  //     final http.Response response = await http.delete(url);
  //     if (response.statusCode != 200) {
  //       return const Left("can't delete this event");
  //     }
  //     return const Right(true);
  //   } catch (e) {
  //     return Left(e.toString());
  //   }
  // }
}
