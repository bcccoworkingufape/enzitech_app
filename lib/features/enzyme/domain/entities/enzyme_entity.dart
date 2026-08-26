class EnzymeEntity {
  String id;
  // Id da enzima no cadastro global. Igual a [id] quando este objeto já representa o
  // próprio cadastro global; diferente quando representa um snapshot vinculado a um
  // experimento (usado para pré-marcar a seleção correta na tela de edição).
  String? sourceEnzymeId;
  String name;
  double variableA;
  double variableB;
  String type;
  String formula;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? duration;
  double? weightSample;
  double? weightGround;
  double? size;

  EnzymeEntity({
    required this.id,
    this.sourceEnzymeId,
    required this.name,
    required this.variableA,
    required this.variableB,
    required this.type,
    required this.formula,
    this.createdAt,
    this.updatedAt,
    this.duration,
    this.weightSample,
    this.weightGround,
    this.size,
  });

  @override
  String toString() {
    return "{id: $id, name: $name, variableA: $variableA, variableB: $variableB, type: $type, createdAt: $createdAt, updatedAt $updatedAt}";
  }
}
