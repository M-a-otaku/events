import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import '../../../infrastructure/commons/url_repository.dart';

class LoginRepository {
  Future<Either<String, int>> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = UrlRepository.login(username, password);
      if (url == null) return const Left('Invalid URL');

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return Left('Failed to fetch data: ${response.statusCode}');
      }

      final users = json.decode(response.body) as List<dynamic>?;
      if (users == null || users.isEmpty) return const Left('No users found');

      final user = users.firstWhere(
            (user) => user["username"] == username && user["password"] == password,
        orElse: () => null,
      );

      if (user != null && user["id"] != null) {
        return Right(user["id"]);
      }

      return const Left('Invalid username or password');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
