// 🎯 Dart imports:
import 'dart:convert';

import 'package:enzitech_app/src/shared/extensions/extensions.dart';

enum UserTypeEnum {
  user,
  admin,
}

class UserModel {
  final String token;
  final String name;
  final String email;
  final String id;
  final UserTypeEnum userType;

  UserModel({
    required this.token,
    required this.name,
    required this.email,
    required this.id,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'name': name,
      'email': email,
      'id': id,
      'role': userType.name.capitalizeFirstLetter(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['accessToken'] ?? map['token'],
      name: map['user'] != null ? map['user']['name'] : map['name'],
      email: map['user'] != null ? map['user']['email'] : map['email'],
      id: map['user'] != null ? map['user']['id'] : map['id'],
      userType: map['user'] != null
          ? map['user']['role'] == "User"
              ? UserTypeEnum.user
              : UserTypeEnum.admin
          : map['role'] == "User"
              ? UserTypeEnum.user
              : UserTypeEnum.admin,
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
