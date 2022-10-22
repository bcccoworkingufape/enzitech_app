import 'package:enzitech_app/src/shared/business/domain/enums/user_type_enum.dart';

class UserEntity {
  String token;
  String name;
  String email;
  String id;
  UserTypeEnum userType;

  UserEntity({
    required this.token,
    required this.name,
    required this.email,
    required this.id,
    required this.userType,
  });
}
