// 🎯 Dart imports:
import 'dart:convert';

class UserModel {
  final String token;
  final String name;
  final String email;
  final String id;

  UserModel({
    required this.token,
    required this.name,
    required this.email,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'name': name,
      'email': email,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['accessToken'],
      name: map['user']['name'],
      email: map['user']['email'],
      id: map['user']['id'],
    );
  }

  String toJson() => json.encode(toMap());
}
