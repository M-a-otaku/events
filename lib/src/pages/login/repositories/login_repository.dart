import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import '../../../infrastructure/commons/url_repository.dart';

class LoginRepository {
  Future<Either<String, int>?> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = UrlRepository.login(username, password);

      if (url == null) {
        return const Left('Invalid URL');
      }

      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        return Left('Failed to fetch data: ${response.statusCode}');
      }

      final List<dynamic>? users = json.decode(response.body);

      if (users == null || users.isEmpty) {
        return const Left('No users found');
      }

      for (var user in users) {
        if (user["username"] != null && user["username"] == username) {
          if (user["password"] != null && user["password"] == password) {
            if (user["id"] != null) {
              return Right(user["id"]);
            } else {
              return const Left('User ID not found');
            }
          } else {
            return const Left('Password is not correct');
          }
        }
      }

      return const Left('User not found');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
