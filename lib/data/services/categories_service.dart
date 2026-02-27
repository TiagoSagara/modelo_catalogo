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

class CategoryService {
  final Dio _dio;
  CategoryService(this._dio);

  // Retorna a lista de objetos [slug, name, url]
  Future<Response> getAllCategories() async {
    return await _dio.get('https://dummyjson.com/products/categories');
  }

  // Retorna os produtos de uma categoria específica
  Future<Response> getProductsByCategory(String categorySlug) async {
    return await _dio.get(
      'https://dummyjson.com/products/category/$categorySlug',
    );
  }
}
