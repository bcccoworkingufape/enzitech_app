class ChoosedExperimentCombinationDTO {
  String? enzymeId;
  String? enzymeName;
  String? enzymeFormula;
  String? treatmentId;
  String? treatmentName;

  ChoosedExperimentCombinationDTO({
    this.enzymeId,
    this.enzymeName,
    this.enzymeFormula,
    this.treatmentId,
    this.treatmentName,
  });

  @override
  String toString() {
    return "{enzymeId: $enzymeId, enzymeName: $enzymeName, treatmentId: $treatmentId}, treatmentName: $treatmentName}";
  }
}
