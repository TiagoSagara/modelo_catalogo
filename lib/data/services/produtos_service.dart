import 'package:dio/dio.dart';

class ProductService {
  final Dio _dio = Dio();

  ProductService(Dio dio);

  Future<Response> getProducts() async {
    return await _dio.get('https://dummyjson.com/products');
  }
}
