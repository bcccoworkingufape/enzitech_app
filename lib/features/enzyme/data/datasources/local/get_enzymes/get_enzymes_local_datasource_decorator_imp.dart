// 🎯 Dart imports:
import 'dart:convert';

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
  }

  Future<Either<Failure, List<EnzymeEntity>>> _getInCache() async {
    try {
      var enzymesJsonString = await _keyValueService.getString('enzymes_cache');

      if (enzymesJsonString == null) {
        throw NoResultQueryFailure(message: "a listagem de enzimas");
      }

      var json = jsonDecode(enzymesJsonString);
      var enzymes = (json as List).map((e) => EnzymeDto.fromJson(e)).toList();

      return Right(enzymes);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
