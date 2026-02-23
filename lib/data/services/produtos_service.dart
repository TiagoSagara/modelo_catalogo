import 'package:dio/dio.dart';

class ProductService {
  final Dio _dio;
  ProductService(this._dio);

  Future<Response> getProducts(String query) async {
    final String path = query.isEmpty
        ? 'https://dummyjson.com/products'
        : 'https://dummyjson.com/products/search?q=$query';

    return await _dio.get(path);
  }
}
