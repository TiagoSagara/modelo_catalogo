class Product {
  final int idPrd;
  final String codigo;
  final String descricao;
  final String imagem;
  final double precoVenda;
  final double precoVenda2;
  final double precoVenda3;
  final double quantidadeAtual;
  final int idGrupo;
  final String descricaoGrupo;
  final int idMarca;
  final String descricaoMarca;
  final String status;
  final String aplicacao;

  const Product({
    required this.idPrd,
    required this.codigo,
    required this.descricao,
    required this.imagem,
    required this.precoVenda,
    required this.precoVenda2,
    required this.precoVenda3,
    required this.quantidadeAtual,
    required this.idGrupo,
    required this.descricaoGrupo,
    required this.idMarca,
    required this.descricaoMarca,
    required this.status,
    required this.aplicacao,
  });

  /// Compat: usado por código que referenciava [id]
  int get id => idPrd;

  /// Compat: título exibido nos cards e detalhes
  String get title => descricao;

  /// Compat: URL da imagem principal
  String get thumbnail => imagem;

  /// Compat: preço principal
  double get price => precoVenda;

  /// Estoque inteiro para exibição
  int get stock => quantidadeAtual.toInt();

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idPrd: json['id_prd'] as int,
      codigo: (json['codigo'] ?? '') as String,
      descricao: (json['descricao'] ?? '') as String,
      imagem: (json['imagem'] ?? '') as String,
      precoVenda: (json['preco_venda'] as num? ?? 0).toDouble(),
      precoVenda2: (json['preco_venda2'] as num? ?? 0).toDouble(),
      precoVenda3: (json['preco_venda3'] as num? ?? 0).toDouble(),
      quantidadeAtual: (json['quantidade_atual'] as num? ?? 0).toDouble(),
      idGrupo: (json['id_grupo'] as num? ?? 0).toInt(),
      descricaoGrupo: (json['descricao_grupo'] ?? '') as String,
      idMarca: (json['id_marca'] as num? ?? 0).toInt(),
      descricaoMarca: (json['descricao_marca'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      aplicacao: (json['aplicacao'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_prd': idPrd,
    'codigo': codigo,
    'descricao': descricao,
    'imagem': imagem,
    'preco_venda': precoVenda,
    'preco_venda2': precoVenda2,
    'preco_venda3': precoVenda3,
    'quantidade_atual': quantidadeAtual,
    'id_grupo': idGrupo,
    'descricao_grupo': descricaoGrupo,
    'id_marca': idMarca,
    'descricao_marca': descricaoMarca,
    'status': status,
    'aplicacao': aplicacao,
  };
}
