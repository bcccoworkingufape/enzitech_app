// 🌎 Project imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../save_theme_mode_datasource.dart';

class SaveThemeModeLocalDataSourceImp extends SaveThemeModeDataSource {
  final UserPreferencesServices _userPreferencesServices;

  SaveThemeModeLocalDataSourceImp(this._userPreferencesServices);

  @override
  Future<void> call(String value) async {
    await _userPreferencesServices.saveThemeModeAsString(value);
  }
}
