import 'package:api_produtos/data/config/api_config.dart';
import 'package:dio/dio.dart';

class CategoryService {
  final Dio _dio;
  CategoryService(this._dio);

  /// Lista todas as categorias visíveis no e-commerce.
  Future<Response> getCategories({int page = 1, int limit = 100}) async {
    return await _dio.get(
      '${ApiConfig.baseUrl}/categorias-produtos',
      queryParameters: {
        'visivel-ecommerce': true,
        'page': page,
        'limit': limit,
      },
    );
  }
}
