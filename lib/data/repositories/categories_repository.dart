import 'package:api_produtos/data/services/categories_service.dart';
import 'package:api_produtos/domain/models/categories_model.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:dio/dio.dart';

class CategoriesRepository {
  final CategoryListService _categoryListService;
  final CategorySelectProductService _categorySelectProductService;
  final CategoryService _service;

  CategoriesRepository(
    this._categoryListService,
    this._service,
    this._categorySelectProductService,
  );

  Future<Response> getCategoryList() async {
    return await _categoryListService.getCategoryList();
  }

  Future<Response> getCategorySelectProduct(String category) async {
    return await _categorySelectProductService.getCategorySelectProduct(
      category,
    );
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _service.getAllCategories();
      final List data = response.data;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Erro ao carregar categorias");
    }
  }

  // Busca produtos por categoria e mapeia para sua ProductModel existente
  Future<List<Product>> getProductsByCategory(String slug) async {
    try {
      final response = await _service.getProductsByCategory(slug);
      final List productsJson = response.data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Erro ao carregar produtos da categoria");
    }
  }
}
