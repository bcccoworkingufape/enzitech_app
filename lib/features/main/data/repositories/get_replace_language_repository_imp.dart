// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/get_replace_language_repository.dart';
import '../datasources/get_replace_language_datasource.dart';

class GetReplaceLanguageRepositoryImp implements GetReplaceLanguageRepository {
  final GetReplaceLanguageDataSource _getReplaceLanguageDataSource;

  GetReplaceLanguageRepositoryImp(this._getReplaceLanguageDataSource);

  @override
  Future<Either<Failure, bool>> call() async {
    return await _getReplaceLanguageDataSource();
  }
}
