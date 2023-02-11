import 'package:enzitech_app/features/main/domain/entities/enzyme_entity.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test(
    "Should not return null on Enzyme entity",
    () {
      EnzymeEntity enzyme = EnzymeEntity(
        id: "1",
        name: "Enzima",
        type: "Tipo",
        variableA: 0.52,
        variableB: 0.32,
      );

      expect(enzyme, isNotNull);
    },
  );

  // Crie um teste do get_enzymes_usecase.dart
}
