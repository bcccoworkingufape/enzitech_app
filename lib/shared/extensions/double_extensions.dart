import 'package:intl/intl.dart';

extension DoubleExtension on double {
  double get decimalToPercent {
    return this * 100;
  }

  String get formmatedNumber {
    var f = NumberFormat(",###.#####", "pt_BR");
    return f.format(this);
  }

  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
