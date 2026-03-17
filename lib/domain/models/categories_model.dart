class CategoryModel {
  final int idGrp;
  final String nome;

  const CategoryModel({required this.idGrp, required this.nome});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      idGrp: (json['id_grp'] as num).toInt(),
      nome: (json['nome'] ?? '') as String,
    );
  }
}
