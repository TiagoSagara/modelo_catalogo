import 'package:api_produtos/data/services/categories_service.dart';
import 'package:dio/dio.dart';

class CategoriesRepository {
  final CategoryListService _categoryListService;
  final CategoryProductsService _categoryProductsService;
  final CategorySelectProductService _categorySelectProductService;

  CategoriesRepository(
    this._categoryListService,
    this._categoryProductsService,
    this._categorySelectProductService,
  );

  Future<Response> getCategoryList() async {
    return await _categoryListService.getCategoryList();
  }

  Future<Response> getCategoryProducts() async {
    return await _categoryProductsService.getCategoryProducts();
  }

  Future<Response> getCategorySelectProduct(String category) async {
    return await _categorySelectProductService.getCategorySelectProduct(
      category,
    );
  }
}
