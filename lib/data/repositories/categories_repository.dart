import 'package:api_produtos/data/services/categories_service.dart';
import 'package:api_produtos/domain/models/categories_model.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:api_produtos/data/repositories/produtos_repository.dart';

class CategoriesRepository {
  final CategoryService _service;
  final ProductRepository _productRepository;

  CategoriesRepository(this._service, this._productRepository);

  /// Retorna a lista de categorias do e-commerce.
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _service.getCategories();
      final List data = response.data['data'] as List;
      return data
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar categorias');
    }
  }

  /// Busca produtos por ID de categoria.
  Future<List<Product>> getProductsByCategory(
    int categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    return _productRepository.fetchProductsByCategory(
      categoryId,
      page: page,
      limit: limit,
    );
  }
}
