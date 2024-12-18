import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../generated/locales.g.dart';
import '../../../infrastructure/commons/url_repository.dart';
import '../models/event_details_dto.dart';
import '../models/event_details_model.dart';

class EventDetailsRepository {

  Future<Either<String, Map<String, dynamic>>?> purchaseEvent(
      {required String eventId, required EventDetailsDto dto}) async {
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

    } catch (e) {
      return Left("${LocaleKeys.error_error.tr}  ${e.toString()}");
    }
  }

  Future<Either<String, EventDetailsModel>> getEventById({
    required String eventId,
  }) async {
    try {
      final url = UrlRepository.getEventById(eventId: eventId);
      final response = await http.get(url);

      final Map<String, dynamic> event = json.decode(response.body);
      return Right(EventDetailsModel.fromJson(json: event));
    } catch (e) {
      return Left("${LocaleKeys.error_error.tr}  ${e.toString()}");
    }
  }


}
