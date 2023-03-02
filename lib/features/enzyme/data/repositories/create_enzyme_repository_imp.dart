// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/create_enzyme_repository.dart';
import '../datasources/create_enzyme_datasource.dart';

class CreateEnzymeRepositoryImp implements CreateEnzymeRepository {
  final CreateEnzymeDataSource _createEnzymeDataSource;

  CreateEnzymeRepositoryImp(this._createEnzymeDataSource);

  @override
  Future<Either<Failure, Unit>> call({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) async {
    return await _createEnzymeDataSource(
      name: name,
      variableA: variableA,
      variableB: variableB,
      type: type,
    );
  }
}
