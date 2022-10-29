class EnzymeEntity {
  String id;
  String name;
  double variableA;
  double variableB;
  String type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? duration;
  double? weightSample;
  double? weightGround;
  double? size;

  EnzymeEntity({
    required this.id,
    required this.name,
    required this.variableA,
    required this.variableB,
    required this.type,
    this.createdAt,
    this.updatedAt,
    this.duration,
    this.weightSample,
    this.weightGround,
    this.size,
  });
}
