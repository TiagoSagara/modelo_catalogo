// lib/src/ui/search/products/view_model/product_bloc.dart

import 'package:api_produtos/data/repositories/produtos_repository.dart';
import 'package:api_produtos/data/repositories/categories_repository.dart'; // Adicionado
import 'package:api_produtos/src/ui/search/products/view_model/list_search_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  final CategoriesRepository _categoriesRepository; // Adicionado

  ProductBloc(this._productRepository, this._categoriesRepository)
    : super(ProductInitial());

  Future<void> loadProducts(String query, {bool isCategory = false}) async {
    emit(ProductLoading());
    try {
      final products = isCategory
          ? await _categoriesRepository.getProductsByCategory(
              query,
            ) // Endpoint: /category/slug
          : await _productRepository.fetchProducts(
              query,
            ); // Endpoint: /search?q=query

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Erro ao carregar produtos"));
    }
  }
}
