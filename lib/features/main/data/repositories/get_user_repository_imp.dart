// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/get_user_repository.dart';
import '../datasources/get_user_datasource.dart';

class GetUserRepositoryImp implements GetUserRepository {
  final GetUserDataSource _getUserDataSource;

  GetUserRepositoryImp(this._getUserDataSource);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await _getUserDataSource();
  }
}
