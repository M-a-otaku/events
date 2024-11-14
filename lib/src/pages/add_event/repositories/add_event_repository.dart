import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/url_repository.dart';
import '../models/add_event_dto.dart';

class AddEventRepository {

  Future<Either<String, Map<String, dynamic>>?> addEvent(
      {required AddEventDto dto}) async {
    try {
      final url = UrlRepository.events;
      http.Response response = await http.post(
        url,
        body: json.encode(dto.toJson()),
        headers: {"Content-Type": "application/json"},
      );
      final Map<String, dynamic> result = json.decode(response.body);
      if (response.statusCode == 201) {
        return Right(result);
      }
      return const Left('Error');
    } catch (e) {
      print(e.toString());
      return Left(e.toString());
    }
  }

}
