class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String gender;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        username: json['username'],
        gender: json['gender'],
        password: 'password',
      );
}
