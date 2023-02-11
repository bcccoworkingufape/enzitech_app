import '../../../../core/enums/enums.dart';
import '../../domain/entities/user_entity.dart';

extension UserDto on UserEntity {
  static UserEntity fromJson(Map json) {
    return UserEntity(
      token: json['accessToken'],
      name: json['user']['name'],
      email: json['user']['email'],
      id: json['user']['id'],
      userType: json['user']['role'] == 'User'
          ? UserTypeEnum.user
          : UserTypeEnum.admin,
    );
  }

  Map toJson() {
    return {
      'accessToken': token,
      'user': {
        'name': name,
        'email': email,
        'id': id,
        'role': userType == UserTypeEnum.user ? 'User' : 'Admin',
      }
    };
  }
}
