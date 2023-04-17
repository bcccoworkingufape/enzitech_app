class ExperimentRepetitionResultEntity {
  String repetitionId;
  double sample;
  double whiteSample;
  double differenceBetweenSamples;
  double variableA;
  double variableB;
  double curve;
  double correctionFactor;
  int time;
  double volume;
  double weightSample;
  double result;

  ExperimentRepetitionResultEntity({
    required this.repetitionId,
    required this.sample,
    required this.whiteSample,
    required this.differenceBetweenSamples,
    required this.variableA,
    required this.variableB,
    required this.curve,
    required this.correctionFactor,
    required this.time,
    required this.volume,
    required this.weightSample,
    required this.result,
  });
}
