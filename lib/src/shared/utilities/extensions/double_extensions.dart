extension DoubleExtension on double {
  double get decimalToPercent {
    return this * 100;
  }

  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
