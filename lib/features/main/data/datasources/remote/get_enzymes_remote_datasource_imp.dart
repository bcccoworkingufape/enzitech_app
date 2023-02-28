// 🎯 Dart imports:

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/enzyme_entity.dart';
import '../../dto/enzyme_dto.dart';
import '../get_enzymes_datasource.dart';

class GetEnzymesRemoteDataSourceImp implements GetEnzymesDataSource {
  final HttpService _httpService;
  GetEnzymesRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, List<EnzymeEntity>>> call() async {
    try {
      var response = await _httpService.get(API.REQUEST_ENZYMES);
      var result = (response.data as List)
          .map(
            (e) => EnzymeDto.fromJson(e),
          )
          .toList();
      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
