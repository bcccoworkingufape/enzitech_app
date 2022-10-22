// 🎯 Dart imports:
import 'dart:convert';

import 'package:enzitech_app/src/shared/business/domain/entities/auth_request_entity.dart';

class AuthRequestModel {
  final String email;
  final String password;

  AuthRequestModel({
    required this.email,
    required this.password,
  });

  AuthRequestModel copyWith({String? email, String? password}) {
    return AuthRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  AuthRequestEntity toEntity() {
    return AuthRequestEntity(
      email: email,
      password: password,
    );
  }

  factory AuthRequestModel.fromEntity(AuthRequestEntity entity) {
    return AuthRequestModel(
      email: entity.email,
      password: entity.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory AuthRequestModel.fromMap(Map<String, dynamic> map) {
    return AuthRequestModel(
      email: map['email'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthRequestModel.fromJson(String source) =>
      AuthRequestModel.fromMap(json.decode(source));
}
