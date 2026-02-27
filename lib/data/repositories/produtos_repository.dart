import 'package:api_produtos/data/services/produtos_service.dart';
import 'package:api_produtos/domain/models/product_model.dart';

class ProductRepository {
  final ProductService _service;
  ProductRepository(this._service);

  Future<List<Product>> fetchProducts(String query) async {
    try {
      final response = await _service.getProducts(query);

      if (response.data != null && response.data['products'] != null) {
        final List list = response.data['products'];
        return list.map((e) => Product.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      // Log de erro para debug
      print("Erro no Repository: $e");
      rethrow;
    }
  }
}
