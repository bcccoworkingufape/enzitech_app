// 🎯 Dart imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../clear_user_datasource.dart';

class ClearUserLocalDataSourceImp extends ClearUserDataSource {
  final UserPreferencesServices _userPreferencesServices;

  ClearUserLocalDataSourceImp(this._userPreferencesServices);

  @override
  Future<void> call() async {
    await _userPreferencesServices.clearAll();
  }
}
