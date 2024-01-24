// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../../core/failures/failures.dart';
import '../../get_theme_mode_datasource.dart';

class GetThemeModeLocalDataSourceImp extends GetThemeModeDataSource {
  final UserPreferencesServices _userPreferencesServices;

  GetThemeModeLocalDataSourceImp(this._userPreferencesServices);

  @override
  Future<Either<Failure, String>> call() async {
    try {
      var response = await _userPreferencesServices.getThemeModeAsString();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
