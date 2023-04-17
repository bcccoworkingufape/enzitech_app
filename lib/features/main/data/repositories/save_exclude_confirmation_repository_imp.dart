// 🌎 Project imports:
import '../../domain/repositories/save_exclude_confirmation_repository.dart';
import '../datasources/save_exclude_confirmation_datasource.dart';

class SaveExcludeConfirmationRepositoryImp
    implements SaveExcludeConfirmationRepository {
  final SaveExcludeConfirmationDataSource _saveExcludeConfirmationDataSource;

  SaveExcludeConfirmationRepositoryImp(this._saveExcludeConfirmationDataSource);

  @override
  Future<void> call(bool value) async {
    return await _saveExcludeConfirmationDataSource(value);
  }
}
