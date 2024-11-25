import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:either_dart/either.dart';
import '../../../../generated/locales.g.dart';
import '../../../infrastructure/commons/url_repository.dart';

class LoginRepository {
  Future<Either<String, int>> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = UrlRepository.login(username, password);

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return Left('${LocaleKeys.error_error.tr}: ${response.statusCode}');
      }

      final users = json.decode(response.body) as List<dynamic>?;
      if (users == null || users.isEmpty) {
        return Left(LocaleKeys.error_repository_login_no_user.tr);
      }

      final user = users.firstWhere(
        (user) => user["username"] == username && user["password"] == password,
        orElse: () => null,
      );

      if (user != null && user["id"] != null) {
        return Right(user["id"]);
      }

      return Left(LocaleKeys.error_repository_login_invalid.tr);
    } catch (e) {
      return Left("${LocaleKeys.error_error.tr}  ${e.toString()}");
    }
  }
}
