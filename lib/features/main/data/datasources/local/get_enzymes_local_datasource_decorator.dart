import 'package:dartz/dartz.dart';
import '../../../domain/entities/enzyme_entity.dart';

import '../../../../../core/failures/failures.dart';
import '../get_enzymes_datasource.dart';

abstract class GetEnzymesDataSourceDecorator implements GetEnzymesDataSource {
  final GetEnzymesDataSource _getEnzymesDataSource;

  GetEnzymesDataSourceDecorator(this._getEnzymesDataSource);

  @override
  Future<Either<Failure, List<EnzymeEntity>>> call() => _getEnzymesDataSource();
}
