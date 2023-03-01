// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/delete_enzyme_repository.dart';
import '../datasources/delete_enzyme_datasource.dart';

class DeleteEnzymeRepositoryImp implements DeleteEnzymeRepository {
  final DeleteEnzymeDataSource _deleteEnzymeDataSource;

  DeleteEnzymeRepositoryImp(this._deleteEnzymeDataSource);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await _deleteEnzymeDataSource(id);
  }
}
