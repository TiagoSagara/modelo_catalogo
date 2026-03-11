import 'package:api_produtos/data/repositories/produtos_repository.dart';
import 'package:api_produtos/data/repositories/categories_repository.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:api_produtos/src/ui/search/products/view_model/list_search_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  final CategoriesRepository _categoriesRepository;

  ProductBloc(this._productRepository, this._categoriesRepository)
    : super(ProductInitial());

  List<Product> _allProducts = [];
  int _currentSkip = 0;
  bool _isFetching = false;

  Future<void> loadProducts(
    String query, {
    bool isCategory = false,
    bool isLoadMore = false,
  }) async {
    if (_isFetching) return;

    if (!isLoadMore) {
      _currentSkip = 0;
      _allProducts = [];
      emit(ProductLoading());
    }

    _isFetching = true;

    try {
      final newProducts = isCategory
          ? await _categoriesRepository.getProductsByCategory(query)
          : await _productRepository.fetchProducts(query, skip: _currentSkip);

      _allProducts.addAll(newProducts);
      _currentSkip += newProducts.length;

      bool reachedMax = newProducts.length < 20;

      emit(ProductLoaded(List.from(_allProducts), hasReachedMax: reachedMax));
    } catch (e) {
      emit(ProductError("Erro ao carregar produtos"));
    } finally {
      _isFetching = false;
    }
  }
}
