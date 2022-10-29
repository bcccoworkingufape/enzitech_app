class TreatmentEntity {
  String name;
  String description;
  String id;
  DateTime? createdAt;
  DateTime? updatedAt;

  TreatmentEntity({
    required this.name,
    required this.description,
    required this.id,
    this.createdAt,
    this.updatedAt,
  });
}
