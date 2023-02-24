// 🎯 Dart imports:
import 'dart:convert';
import 'dart:developer';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/key_value/key_value_service.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../domain/entities/enzyme_entity.dart';
import '../../../dto/enzyme_dto.dart';
import '../../get_enzymes_datasource.dart';
import 'get_enzymes_local_datasource_decorator.dart';

class GetEnzymesDataSourceDecoratorImp extends GetEnzymesDataSourceDecorator {
  final KeyValueService _keyValueService;

  GetEnzymesDataSourceDecoratorImp(
      GetEnzymesDataSource getEnzymesDataSource, this._keyValueService)
      : super(getEnzymesDataSource);

  @override
  Future<Either<Failure, List<EnzymeEntity>>> call() async {
    print('-> entrou dso Decorator');
    return (await super()).fold(
      (error) async => error is ExpiredTokenOrWrongUserFailure
          ? Left(error)
          : await _getInCache(),
      (result) {
        _saveInCache(result);
        return Right(result);
      },
    );
  }

  _saveInCache(List<EnzymeEntity> enzymes) async {
    String json = jsonEncode(
      enzymes.map((i) => i.toJson()).toList(),
    ).toString();

    _keyValueService.setString('enzymes_cache', json);
    log('-> Enzymes saved on cache');
  }

  Future<Either<Failure, List<EnzymeEntity>>> _getInCache() async {
    try {
      log('-> Enzymes get on cache');

      var enzymesJsonString = await _keyValueService.getString('enzymes_cache');

      if (enzymesJsonString == null) {
        log('-> Enzymes recover exception');

        throw NoResultQueryFailure(message: "a listagem de enzimas");
      }

      var json = jsonDecode(enzymesJsonString);
      var enzymes = (json as List).map((e) => EnzymeDto.fromJson(e)).toList();

      log('-> Enzymes recovered from cache: ${enzymes.toString()}');
      return Right(enzymes);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
