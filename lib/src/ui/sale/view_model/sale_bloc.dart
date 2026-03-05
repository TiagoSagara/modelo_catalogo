import 'package:api_produtos/domain/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SaleState {}

class SaleInitial extends SaleState {}

class SaleLoading extends SaleState {}

class SaleLoaded extends SaleState {
  final List<Product> products;
  final double totalValue;
  SaleLoaded(this.products, this.totalValue);
}

class SaleBloc extends Cubit<SaleState> {
  // Lista interna privada para gerenciar os itens
  final List<Product> _cartItems = [];

  SaleBloc() : super(SaleInitial());

  void addToCart(Product product) {
    _cartItems.add(product);
    _updateCart();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    _updateCart();
  }

  void _updateCart() {
    emit(SaleLoading());
    double total = _cartItems.fold(0, (sum, item) => sum + (item.price ?? 0));
    emit(SaleLoaded(List.from(_cartItems), total));
  }
}
