import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final DateTime birthDate;
  final String role;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.birthDate,
      required this.role});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

/*class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final DateTime birthdate;
  final String role;

  User(
      {required this.id,
        required this.name,
        required this.email,
        required this.password,
        required this.birthdate,
        required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      birthdate: json['birthdate'] != null
          ? DateTime.parse(json['birthdate'])
          : DateTime.now(),
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'birthdate': birthdate,
      'role': role,
    };
  }
}*/
