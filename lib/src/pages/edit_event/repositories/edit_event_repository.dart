import 'dart:convert';
import 'package:either_dart/either.dart';
import '../models/edit_events_model.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/url_repository.dart';
import '../models/edit_event_dto.dart';

class EditEventRepository {
  Future<Either<String, Map<String, dynamic>>?> editEvent(
      {required String eventId, required EditEventDto dto}) async {
    try {
      final url = UrlRepository.getEventById(eventId: eventId);
      http.Response response = await http.patch(
        url,
        body: json.encode(dto.toJson()),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        return const Left(
          "something went wrong can't edit",
        );
      }

      final Map<String, dynamic> result = json.decode(response.body);
      return Right(result);

      return const Left('Error');
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, EditEventsModel>> getEventById({
    required String eventId,
  }) async {
    try {
      final url = UrlRepository.getEventById(eventId: eventId);
      final response = await http.get(url);

      final Map<String, dynamic> event = json.decode(response.body);
      return Right(EditEventsModel.fromJson(json: event));
    } catch (e) {
      return Left(e.toString());
    }
  }


}
