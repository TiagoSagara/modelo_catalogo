import 'package:api_produtos/data/services/checkout_service.dart';
import 'package:api_produtos/domain/models/sale_model.dart';

class CheckoutRepository {
  final CheckoutService _service;
  CheckoutRepository(this._service);

  /// Cria uma nova venda e retorna a resposta completa.
  Future<SaleResponse> createSale(SaleRequest request) async {
    final response = await _service.createSale(request.toJson());
    return SaleResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Consulta uma venda pelo ID.
  Future<SaleResponse> getSaleById(int saleId) async {
    final response = await _service.getSaleById(saleId);
    return SaleResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
