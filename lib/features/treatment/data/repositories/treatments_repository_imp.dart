// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/treatment_entity.dart';
import '../../domain/repositories/treatments_repository.dart';
import '../datasources/treatments_datasource.dart';

class TreatmentsRepositoryImp implements TreatmentsRepository {
  final TreatmentsDataSource _treatmentsDataSource;

  TreatmentsRepositoryImp(this._treatmentsDataSource);

  @override
  Future<Either<Failure, Unit>> createTreatment({required String name, required String description}) async {
    return await _treatmentsDataSource.createTreatment(name: name, description: description);
  }

  @override
  Future<Either<Failure, Unit>> deleteTreatment(String id) async {
    return await _treatmentsDataSource.deleteTreatment(id);
  }

  @override
  Future<Either<Failure, List<TreatmentEntity>>> getTreatments() async {
    return await _treatmentsDataSource.getTreatments();
  }
}
