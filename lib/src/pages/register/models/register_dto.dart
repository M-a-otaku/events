
class RegisterDto {
  final String firstname;
  final String lastname;
  final String username;
  final String password;
  final String gender;

  RegisterDto(
      {required this.gender,
      required this.firstname,
      required this.lastname,
      required this.username,
      required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'gender': gender,
      };
}
