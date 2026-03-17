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
  int _currentPage = 1;
  bool _isFetching = false;
  static const int _pageSize = 20;

  Future<void> loadProducts(
    String query, {
    bool isCategory = false,
    bool isLoadMore = false,
    int? categoryId,
  }) async {
    if (_isFetching) return;

    if (!isLoadMore) {
      _currentPage = 1;
      _allProducts = [];
      emit(ProductLoading());
    }

    _isFetching = true;

    try {
      List<Product> newProducts;

      if (isCategory && categoryId != null) {
        newProducts = await _categoriesRepository.getProductsByCategory(
          categoryId,
          page: _currentPage,
          limit: _pageSize,
        );
      } else {
        newProducts = await _productRepository.fetchProducts(
          query,
          page: _currentPage,
          limit: _pageSize,
        );
      }

      _allProducts.addAll(newProducts);
      _currentPage++;

      final bool reachedMax = newProducts.length < _pageSize;

      emit(ProductLoaded(List.from(_allProducts), hasReachedMax: reachedMax));
    } catch (e) {
      emit(ProductError('Erro ao carregar produtos'));
    } finally {
      _isFetching = false;
    }
  }
}
