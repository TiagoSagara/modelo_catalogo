import 'package:api_produtos/data/config/api_config.dart';
import 'package:dio/dio.dart';

class CheckoutService {
  final Dio _dio;
  CheckoutService(this._dio);

  /// Cria uma nova venda via POST /vendas.
  Future<Response> createSale(Map<String, dynamic> saleJson) async {
    return await _dio.post(
      '${ApiConfig.baseUrl}/vendas',
      data: saleJson,
    );
  }

  /// Consulta uma venda pelo ID via GET /vendas/:id.
  Future<Response> getSaleById(int saleId) async {
    return await _dio.get('${ApiConfig.baseUrl}/vendas/$saleId');
  }
}
