// 📦 Package imports:
import 'package:dartz/dartz.dart';
import 'package:enzitech_app/features/main/data/datasources/get_treatments_datasource.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/treatment_entity.dart';
import '../../domain/repositories/get_treatments_repository.dart';

class GetTreatmentsRepositoryImp implements GetTreatmentsRepository {
  final GetTreatmentsDataSource _getTreatmentsDataSource;

  GetTreatmentsRepositoryImp(this._getTreatmentsDataSource);

  @override
  Future<Either<Failure, List<TreatmentEntity>>> call() async {
    return await _getTreatmentsDataSource();
  }
}
