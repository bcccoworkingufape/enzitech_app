// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/controllers/enzymes_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/enzymes_repo.dart';

class EnzymesController implements IEnzymesController {
  final EnzymesRepo enzymesRepo;

  EnzymesController({
    required this.enzymesRepo,
  });

  @override
  Future<List<EnzymeEntity>> getEnzymes() async {
    return enzymesRepo.getEnzymes();
  }

  @override
  Future<void> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) async {
    return enzymesRepo.createEnzyme(
      name: name,
      variableA: variableA,
      variableB: variableB,
      type: type,
    );
  }

  @override
  Future<void> deleteEnzyme(String id) async {
    return enzymesRepo.deleteEnzyme(id);
  }
}
