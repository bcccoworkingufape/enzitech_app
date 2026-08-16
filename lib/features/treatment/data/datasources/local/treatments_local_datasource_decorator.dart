// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failures.dart';
import '../../../domain/entities/treatment_entity.dart';
import '../treatments_datasource.dart';

abstract class TreatmentsDataSourceDecorator implements TreatmentsDataSource {
  final TreatmentsDataSource _treatmentsDataSource;

  TreatmentsDataSourceDecorator(this._treatmentsDataSource);

  @override
  Future<Either<Failure, List<TreatmentEntity>>> getTreatments() => _treatmentsDataSource.getTreatments();

  @override
  Future<Either<Failure, Unit>> deleteTreatment(String id) => _treatmentsDataSource.deleteTreatment(id);

  @override
  Future<Either<Failure, TreatmentEntity>> createTreatment({required String name, required String description}) =>
      _treatmentsDataSource.createTreatment(name: name, description: description);
}
