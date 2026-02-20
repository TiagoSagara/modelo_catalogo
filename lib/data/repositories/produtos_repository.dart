import 'package:api_produtos/data/services/produtos_service.dart';
import '../../domain/models/product_model.dart';

class ProductRepository {
  final ProductService _service;
  ProductRepository(this._service);

  Future<List<Product>> fetchProducts() async {
    final response = await _service.getProducts();
    final List list = response.data['products'];
    return list.map((e) => Product.fromJson(e)).toList();
  }
}
