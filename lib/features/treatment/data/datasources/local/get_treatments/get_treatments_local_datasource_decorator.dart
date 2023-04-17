// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/failures/failures.dart';
import '../../../../domain/entities/treatment_entity.dart';
import '../../get_treatments_datasource.dart';

abstract class GetTreatmentsDataSourceDecorator
    implements GetTreatmentsDataSource {
  final GetTreatmentsDataSource _getEnzymesDataSource;

  GetTreatmentsDataSourceDecorator(this._getEnzymesDataSource);

  @override
  Future<Either<Failure, List<TreatmentEntity>>> call() =>
      _getEnzymesDataSource();
}
