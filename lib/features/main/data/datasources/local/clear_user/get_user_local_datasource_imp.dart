// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../authentication/data/dto/user_dto.dart';
import '../../../../../authentication/domain/entities/user_entity.dart';
import '../../get_user_datasource.dart';

class GetUserLocalDataSourceImp extends GetUserDataSource {
  final UserPreferencesServices _userPreferencesServices;

  GetUserLocalDataSourceImp(this._userPreferencesServices);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    try {
      var response = await _userPreferencesServices.getFullUser();
      if (response == null) {
        throw NoResultQueryFailure(message: "os dados do usuário");
      } else {
        var result = UserDto.fromJson(jsonDecode(response));
        return Right(result);
      }
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
