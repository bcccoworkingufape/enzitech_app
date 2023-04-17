class NumberDifferencesDTO {
  final num differenceOfFartherNumber;
  final num fartherNumber;
  final num? number;
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
