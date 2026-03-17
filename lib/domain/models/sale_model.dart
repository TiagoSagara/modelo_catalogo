class SaleItemRequest {
  final int idProduto;
  final double quantidade;
  final double preco;
  final double valorDesconto;

  const SaleItemRequest({
    required this.idProduto,
    required this.quantidade,
    required this.preco,
    this.valorDesconto = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'idProduto': idProduto,
    'quantidade': quantidade,
    'preco': preco,
    'valorDesconto': valorDesconto,
  };
}

class SaleRequest {
  final double valorBruto;
  final double valorLiquido;
  final double valorDesconto;
  final String? observacao;
  final String? identificacaoCliente;
  final List<SaleItemRequest> itens;

  const SaleRequest({
    required this.valorBruto,
    required this.valorLiquido,
    required this.itens,
    this.valorDesconto = 0.0,
    this.observacao,
    this.identificacaoCliente,
  });

  Map<String, dynamic> toJson() => {
    'valorBruto': valorBruto,
    'valorLiquido': valorLiquido,
    'valorDesconto': valorDesconto,
    if (observacao != null) 'observacao': observacao,
    if (identificacaoCliente != null)
      'identificacaoCliente': identificacaoCliente,
    'itens': itens.map((i) => i.toJson()).toList(),
  };
}

class SaleItemResponse {
  final int item;
  final int idProduto;
  final String descricaoProduto;
  final double quantidade;
  final double preco;
  final double valorBruto;
  final double valorLiquido;
  final double valorDesconto;

  const SaleItemResponse({
    required this.item,
    required this.idProduto,
    required this.descricaoProduto,
    required this.quantidade,
    required this.preco,
    required this.valorBruto,
    required this.valorLiquido,
    required this.valorDesconto,
  });

  factory SaleItemResponse.fromJson(Map<String, dynamic> json) {
    return SaleItemResponse(
      item: (json['item'] as num).toInt(),
      idProduto: (json['id_produto'] as num).toInt(),
      descricaoProduto: (json['descricao_produto'] ?? '') as String,
      quantidade: (json['quantidade'] as num? ?? 0).toDouble(),
      preco: (json['preco'] as num? ?? 0).toDouble(),
      valorBruto: (json['valor_bruto'] as num? ?? 0).toDouble(),
      valorLiquido: (json['valor_liquido'] as num? ?? 0).toDouble(),
      valorDesconto: (json['valor_desconto'] as num? ?? 0).toDouble(),
    );
  }
}

class SaleResponse {
  final int idSds;
  final String status;
  final String dataHora;
  final double valorBruto;
  final double valorLiquido;
  final double valorDesconto;
  final String? identificacaoCliente;
  final List<SaleItemResponse> itens;

  const SaleResponse({
    required this.idSds,
    required this.status,
    required this.dataHora,
    required this.valorBruto,
    required this.valorLiquido,
    required this.valorDesconto,
    this.identificacaoCliente,
    required this.itens,
  });

  factory SaleResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final List itensJson = data['itens'] as List? ?? [];
    return SaleResponse(
      idSds: (data['id_sds'] as num).toInt(),
      status: (data['status'] ?? '') as String,
      dataHora: (data['data_hora'] ?? '') as String,
      valorBruto: (data['valor_bruto'] as num? ?? 0).toDouble(),
      valorLiquido: (data['valor_liquido'] as num? ?? 0).toDouble(),
      valorDesconto: (data['valor_desconto'] as num? ?? 0).toDouble(),
      identificacaoCliente: data['identificacao_cliente'] as String?,
      itens: itensJson
          .map((e) => SaleItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
