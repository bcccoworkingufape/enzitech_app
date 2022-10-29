// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';

abstract class IEnzymesRepo {
  Future<List<EnzymeEntity>> getEnzymes();
  Future<void> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  });
  Future<void> deleteEnzyme(
    String id,
  );
}
