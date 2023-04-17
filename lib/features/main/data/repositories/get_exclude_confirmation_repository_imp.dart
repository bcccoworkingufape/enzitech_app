// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/get_exclude_confirmation_repository.dart';
import '../datasources/get_exclude_confirmation_datasource.dart';

class GetExcludeConfirmationRepositoryImp
    implements GetExcludeConfirmationRepository {
  final GetExcludeConfirmationDataSource _getExcludeConfirmationDataSource;

  GetExcludeConfirmationRepositoryImp(this._getExcludeConfirmationDataSource);

  @override
  Future<Either<Failure, bool>> call() async {
    return await _getExcludeConfirmationDataSource();
  }
}
