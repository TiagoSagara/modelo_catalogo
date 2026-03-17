import 'package:api_produtos/data/services/produtos_service.dart';
import 'package:api_produtos/domain/models/product_model.dart';

class ProductRepository {
  final ProductService _service;
  ProductRepository(this._service);

  /// Busca produtos com busca textual e paginação por página.
  Future<List<Product>> fetchProducts(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _service.getProducts(
        query,
        page: page,
        limit: limit,
      );
      final List list = response.data['data'] as List;
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca produtos de uma categoria pelo ID.
  Future<List<Product>> fetchProductsByCategory(
    int categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _service.getProducts(
        '',
        page: page,
        limit: limit,
        categoriaId: categoryId,
      );
      final List list = response.data['data'] as List;
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Busca um produto pelo ID.
  Future<Product> fetchProductById(int id) async {
    final response = await _service.getProductById(id);
    final List data = response.data['data'] as List;
    return Product.fromJson(data.first as Map<String, dynamic>);
  }
}
