import 'events_model.dart';

class UserModel {
  String firstName;
  String lastName;
  String gender;
  String username;
  String password;
  int id;
  List<EventsModel> bookmark;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.username,
    required this.password,
    required this.bookmark,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      firstName: json["firstname"],
      lastName: json["lastname"],
      gender: json["gender"],
      username: json["username"],
      password: json["password"],
      bookmark: json["bookmark"],
    );
  }

  @override
  String toString() {
    return 'id $id $firstName $lastName $gender $username $password';
  }
}
