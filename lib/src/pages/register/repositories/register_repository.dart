import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../infrastructure/commons/url_repository.dart';
import '../models/register_dto.dart';

class RegisterRepository {
  Future<Either<String, Map<String, dynamic>>?> register(
      RegisterDto dto) async {
    try {
      final url = UrlRepository.users;

      // check if user already exist
      final http.Response check = await http.get(url);
      final List<dynamic> checkResponse = json.decode(check.body);
      if (checkResponse.any((user) => user["name"] == dto.username)) {
        return Left('User ${dto.username} is Already Exist, try to login');
      }

      // create a user in data-base
      final Map<String, dynamic> body = dto.toJson();
      final http.Response response = await http.post(url, body: body);

      if (response.statusCode != 201) return const Left('bad request');

      final Map<String, dynamic> result = json.decode(response.body);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
