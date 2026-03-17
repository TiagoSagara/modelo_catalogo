import 'package:api_produtos/data/config/api_config.dart';
import 'package:dio/dio.dart';

class ProductService {
  final Dio _dio;
  ProductService(this._dio);

  /// Lista produtos com filtros e paginação.
  Future<Response> getProducts(
    String query, {
    int page = 1,
    int limit = 20,
    int? categoriaId,
  }) async {
    return await _dio.get(
      '${ApiConfig.baseUrl}/produtos',
      queryParameters: {
        if (query.isNotEmpty) 'descricao': query,
        if (categoriaId != null) 'categoria': categoriaId,
        'page': page,
        'limit': limit,
        'status-produto': 'A',
        'visivel-ecommerce': true,
      },
    );
  }

  /// Retorna um produto pelo seu ID.
  Future<Response> getProductById(int id) async {
    return await _dio.get('${ApiConfig.baseUrl}/produtos/$id');
  }
}
