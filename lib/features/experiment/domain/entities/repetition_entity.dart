class RepetitionEntity {
  String id;
  String treatmentId;
  String treatmentName;
  String enzymeId;
  String enzymeName;
  int repetitionNumber;
  String status;
  double? sample;
  double? whiteSample;
  double? differenceBetweenSamples;
  double? curve;
  double? result;

  RepetitionEntity({
    required this.id,
    required this.treatmentId,
    required this.treatmentName,
    required this.enzymeId,
    required this.enzymeName,
    required this.repetitionNumber,
    required this.status,
    this.sample,
    this.whiteSample,
    this.differenceBetweenSamples,
    this.curve,
    this.result,
  });

  bool get isCompleted => status == 'COMPLETED';
}
