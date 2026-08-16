class TreatmentEntity {
  String id;
  // Id do tratamento no cadastro global. Igual a [id] quando este objeto já representa
  // o próprio cadastro global; diferente quando representa um snapshot vinculado a um
  // experimento (usado para pré-marcar a seleção correta na tela de edição).
  String? sourceTreatmentId;
  String name;
  String description;
  DateTime? createdAt;
  DateTime? updatedAt;

  TreatmentEntity({
    required this.id,
    this.sourceTreatmentId,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });
}
