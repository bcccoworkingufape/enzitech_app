// 🌎 Project imports:
import '../../domain/repositories/clear_user_repository.dart';
import '../datasources/clear_user_datasource.dart';

class ClearUserRepositoryImp implements ClearUserRepository {
  final ClearUserDataSource _clearUserDataSource;

  ClearUserRepositoryImp(this._clearUserDataSource);

  @override
  Future<void> call() async {
    return await _clearUserDataSource();
  }
}
