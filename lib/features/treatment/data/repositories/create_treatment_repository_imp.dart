// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/create_treatment_repository.dart';
import '../datasources/create_treatment_datasource.dart';

class CreateTreatmentRepositoryImp implements CreateTreatmentRepository {
  final CreateTreatmentDataSource _createTreatmentDataSource;

  CreateTreatmentRepositoryImp(this._createTreatmentDataSource);

  @override
  Future<Either<Failure, Unit>> call({
    required String name,
    required String description,
  }) async {
    return await _createTreatmentDataSource(
      name: name,
      description: description,
    );
  }
}
