import 'package:dio/dio.dart';

class CategoryListService {
  final Dio _dio;
  CategoryListService(this._dio);

  Future<Response> getCategoryList() async {
    final String path = 'https://dummyjson.com/products/category-list';

    return await _dio.get(path);
  }
}

class CategorySelectProductService {
  final Dio _dio;
  CategorySelectProductService(this._dio);

  Future<Response> getCategorySelectProduct(String category) async {
    final String path = 'https://dummyjson.com/products/category/$category';

    return await _dio.get(path);
  }
}

// AJUSTAR - RESPOSTA POSSUÍ UM JSON A MAIS COM OS PRODUTOS
class CategoryProductsService {
  final Dio _dio;
  CategoryProductsService(this._dio);

  Future<Response> getCategoryProducts() async {
    final String path = 'https://dummyjson.com/products/categories';

    return await _dio.get(path);
  }
}
