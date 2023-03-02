// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../../enzyme/data/dto/enzyme_dto.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../dto/experiment_dto.dart';
import '../create_experiment_datasource.dart';

class CreateExperimentRemoteDataSourceImp
    implements CreateExperimentDataSource {
  final HttpService _httpService;
  CreateExperimentRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentEntity>> call({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    try {
      List<Map> experimentsEnzymes =
          enzymes.map((enzyme) => enzyme.toJsonAsExperimentEnzymes()).toList();

      var response = await _httpService.post(
        API.REQUEST_EXPERIMENTS,
        data: {
          "name": name,
          "description": description,
          "repetitions": repetitions,
          "processes": treatmentsIDs,
          "experimentsEnzymes": experimentsEnzymes,
        },
      );

      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
