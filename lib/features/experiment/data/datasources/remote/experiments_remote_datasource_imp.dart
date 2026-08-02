// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failures.dart';
import '../../../../../shared/utils/api.dart';
import '../../../../enzyme/data/dto/enzyme_dto.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../../domain/entities/experiment_pagination_entity.dart';
import '../../../domain/entities/experiment_result_entity.dart';
import '../../../domain/entities/repetition_entity.dart';
import '../../dto/experiment_dto.dart';
import '../../dto/experiment_pagination_dto.dart';
import '../../dto/experiment_result_dto.dart';
import '../../dto/repetition_dto.dart';
import '../experiments_datasource.dart';

class ExperimentsRemoteDataSourceImp implements ExperimentsDataSource {
  final HttpService _httpService;

  ExperimentsRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, List<RepetitionEntity>>> getRepetitions({required String experimentId}) async {
    try {
      var response = await _httpService.get(API.REQUEST_REPETITIONS(experimentId));

      var result = (response.data as List).map((e) => RepetitionDto.fromJson(e)).toList();

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, RepetitionEntity>> previewRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) async {
    try {
      var response = await _httpService.post(
        API.REQUEST_PREVIEW_REPETITION(experimentId),
        data: {
          "treatmentId": treatmentId,
          "enzymeId": enzymeId,
          "repetitionNumber": repetitionNumber,
          "sample": sample,
          "whiteSample": whiteSample,
        },
      );

      var result = RepetitionDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentEntity>> saveRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) async {
    try {
      var response = await _httpService.put(
        API.REQUEST_REPETITIONS(experimentId),
        data: {
          "treatmentId": treatmentId,
          "enzymeId": enzymeId,
          "repetitionNumber": repetitionNumber,
          "sample": sample,
          "whiteSample": whiteSample,
        },
      );

      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentEntity>> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    try {
      List<Map> experimentsEnzymes = enzymes.map((enzyme) => enzyme.toJsonAsExperimentEnzyme()).toList();

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

  @override
  Future<Either<Failure, ExperimentEntity>> updateExperiment({
    required String experimentId,
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    try {
      List<Map> experimentsEnzymes = enzymes.map((enzyme) => enzyme.toJsonAsExperimentEnzyme()).toList();

      var response = await _httpService.put(
        API.REQUEST_EXPERIMENTS_WITH_ID(experimentId),
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

  @override
  Future<Either<Failure, Unit>> deleteExperiment(String id) async {
    try {
      await _httpService.delete(API.REQUEST_EXPERIMENTS_WITH_ID(id));
      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentEntity>> getExperimentById(String id) async {
    try {
      var response = await _httpService.get(API.REQUEST_EXPERIMENTS_WITH_ID(id));

      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    try {
      var addOrderBy = orderBy != null ? "&orderBy=$orderBy" : "";
      var addOrdering = ordering != null ? "&ordering=$ordering" : "";
      var addLimit = limit != null ? "&limit=$limit" : "";
      var addFinished = finished != null ? "&finished=$finished" : "";

      var response = await _httpService.get(
        '${API.REQUEST_EXPERIMENTS}?page=$page$addOrderBy$addOrdering$addLimit$addFinished',
      );

      var result = ExperimentPaginationDto.fromJson(response.data);

      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Falha não mapeada nos Experimentos: $e'));
    }
  }

  @override
  Future<Either<Failure, ExperimentResultEntity>> getResult({required String experimentId}) async {
    try {
      var response = await _httpService.get(API.REQUEST_GET_RESULT_EXPERIMENTS(experimentId));

      var result = ExperimentResultDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, EnzymeEntity>> updateEnzymeFormula({
    required String experimentId,
    required String experimentEnzymeId,
    String? customFormulaCurve,
    String? customFormulaCalculation,
  }) async {
    try {
      var response = await _httpService.patch(
        API.REQUEST_ENZYME_FORMULA(experimentId, experimentEnzymeId),
        data: {"customFormulaCurve": customFormulaCurve, "customFormulaCalculation": customFormulaCalculation},
      );

      var result = EnzymeDto.fromExperimentEnzymeConfigJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  /// Do not implement or use this method here!
  /// If you want to use storeInCache do using the local repository
  @override
  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity) {
    throw UnimplementedError();
  }
}
