// 🌎 Project imports:
import '../../domain/repositories/save_replace_language_repository.dart';
import '../datasources/save_replace_language_datasource.dart';

class SaveReplaceLanguageRepositoryImp implements SaveReplaceLanguageRepository {
  final SaveReplaceLanguageDataSource _saveReplaceLanguageDataSource;

  SaveReplaceLanguageRepositoryImp(this._saveReplaceLanguageDataSource);

  @override
  Future<void> call(bool value) async {
    return await _saveReplaceLanguageDataSource(value);
  }
}
