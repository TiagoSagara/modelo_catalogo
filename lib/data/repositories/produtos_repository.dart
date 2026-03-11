import 'package:api_produtos/data/services/produtos_service.dart';
import 'package:api_produtos/domain/models/product_model.dart';

class ProductRepository {
  final ProductService _service;
  ProductRepository(this._service);

  Future<List<Product>> fetchProducts(String query, {int skip = 0}) async {
    try {
      final response = await _service.getProducts(query, skip: skip);
      final List list = response.data['products'];
      return list.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
