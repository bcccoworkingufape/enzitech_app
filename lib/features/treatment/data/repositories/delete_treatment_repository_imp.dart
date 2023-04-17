// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/repositories/delete_treatment_repository.dart';
import '../datasources/delete_treatment_datasource.dart';

class DeleteTreatmentRepositoryImp implements DeleteTreatmentRepository {
  final DeleteTreatmentDataSource _deleteTreatmentDataSource;

  DeleteTreatmentRepositoryImp(this._deleteTreatmentDataSource);

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await _deleteTreatmentDataSource(id);
  }
}
