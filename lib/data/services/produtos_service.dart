import 'package:dio/dio.dart';

class ProductService {
  final Dio _dio;
  ProductService(this._dio);

  Future<Response> getProducts(
    String query, {
    int skip = 0,
    int limit = 20,
  }) async {
    final String url = query.isEmpty
        ? 'https://dummyjson.com/products'
        : 'https://dummyjson.com/products/search';

    return await _dio.get(
      url,
      queryParameters: {
        if (query.isNotEmpty) 'q': query,
        'skip': skip,
        'limit': limit,
      },
    );
  }
}
