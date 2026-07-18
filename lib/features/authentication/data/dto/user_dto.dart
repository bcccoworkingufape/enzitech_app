// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../domain/entities/user_entity.dart';

extension UserDto on UserEntity {
  static UserEntity fromJson(Map json) {
    return UserEntity(
      token: json['token'] ?? '', 
      name: json['user'] != null ? json['user']['name'] ?? '' : '',
      email: json['user'] != null ? json['user']['email'] ?? '' : '',
      id: json['user'] != null ? json['user']['id'] ?? '' : '',
      userType: (json['user'] != null && json['user']['role'].toString().toUpperCase() == 'ADMIN') 
          ? UserTypeEnum.admin 
          : UserTypeEnum.user,
    );
  }

  Map toJson() {
    return {
      'token': token,
      'user': {
        'name': name, 
        'email': email, 
        'id': id, 
        'role': userType == UserTypeEnum.user ? 'USER' : 'ADMIN'
      },
    };
  }
}