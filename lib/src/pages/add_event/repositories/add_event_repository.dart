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
        body: json.encode(dto),
        headers: {"Content-Type": "application/json"},
      );
      final Map<String, dynamic> result = json.decode(response.body);
      if (response.statusCode == 201) {
        return Right(result);
      }
      return const Left('Error');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> uploadImage() async {
    var image = Rx<File?>(null);
    final url = UrlRepository.events;
    if (image.value == null) {
      return const Left("No image selected");
    }

    var request = http.MultipartRequest(
      'poster', Uri.parse("$url"),
    );
    var picture = await http.MultipartFile.fromPath(
      'file', image.value!.path,
    );
    request.files.add(picture);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        return const Right("Image uploaded successfully");
      } else {
        return const Left("Failed to upload image");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }

}
