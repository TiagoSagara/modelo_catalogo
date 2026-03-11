import 'package:api_produtos/domain/models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;
  ProductLoaded(this.products, {this.hasReachedMax = false});
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
