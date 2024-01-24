// 📦 Package imports:
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:enzitech_app/features/enzyme/domain/entities/enzyme_entity.dart';

main() {
  test(
    "Should not return null on Enzyme entity",
    () {
      EnzymeEntity enzyme = EnzymeEntity(
        id: "1",
        name: "Enzima",
        type: "Tipo",
        formula: "a+b=c",
        variableA: 0.52,
        variableB: 0.32,
      );

      expect(enzyme, isNotNull);
    },
  );
}
