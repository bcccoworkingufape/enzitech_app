// 📦 Package imports:
import 'package:intl/intl.dart';

extension NumExtension on num {
  double get decimalToPercent {
    return this * 100;
  }

  String get formmatedNumber {
    var f = NumberFormat(",###.#####", "pt_BR");
    return f.format(this);
  }

  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
