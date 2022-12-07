import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.email,
    required this.password,
  });

  String username;
  String firstName;
  String lastName;
  DateTime dob;
  String email;
  String password;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: DateTime.parse(json["dob"]),
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "firstName": firstName,
        "lastName": lastName,
        "dob": dob.toIso8601String(),
        "email": email,
        "password": password,
      };
}
