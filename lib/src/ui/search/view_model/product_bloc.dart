import 'package:api_produtos/data/repositories/produtos_repository.dart';
import 'package:api_produtos/src/ui/search/view_model/list_search_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductBloc(this._repository) : super(ProductInitial());

  Future<void> loadProducts(String query) async {
    emit(ProductLoading());
    try {
      final products = await _repository.fetchProducts(query);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError("Erro ao carregar produtos"));
    }
  }
}
