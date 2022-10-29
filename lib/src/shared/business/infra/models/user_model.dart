// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/user_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/user_type_enum.dart';
import 'package:enzitech_app/src/shared/utilities/extensions/extensions.dart';

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

  UserEntity toEntity() {
    return UserEntity(
      token: token,
      name: name,
      email: email,
      id: id,
      userType: userType,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      token: entity.token,
      name: entity.name,
      email: entity.email,
      id: entity.id,
      userType: entity.userType,
    );
  }

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

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
