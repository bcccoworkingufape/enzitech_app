// 📦 Package imports:

import 'package:dartz/dartz.dart';

import '../../../../core/failures/failures.dart';

abstract class DeleteTreatmentDataSource {
  Future<Either<Failure, Unit>> call(String id);
}
