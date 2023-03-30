class NumberDifferencesDTO {
  final double differenceOfFartherNumber;
  final double fartherNumber;
  final double? number;
  final bool? isFarther;

  NumberDifferencesDTO({
    required this.differenceOfFartherNumber,
    required this.fartherNumber,
    this.number,
    this.isFarther,
  });

  @override
  String toString() {
    return "{number: $number, isFarther: $isFarther, differenceOfFartherNumber: $differenceOfFartherNumber}";
  }
}
