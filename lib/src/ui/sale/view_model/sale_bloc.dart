import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SaleState {}

class SaleLoading extends SaleState {}

class SaleLoaded extends SaleState {
  final List<CartItem> products;
  final double totalValue;
  SaleLoaded(this.products, this.totalValue);
}

class SaleError extends SaleState {
  final String message;
  SaleError(this.message);
}

class SaleBloc extends Cubit<SaleState> {
  final List<CartItem> _cartItems = [];

  SaleBloc() : super(SaleLoaded([], 0));

  void addToCart(Product product, {int quantity = 1}) {
    final index = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }
    _updateCart();
  }

  void removeFromCart(CartItem item) {
    _cartItems.removeWhere((c) => c.product.id == item.product.id);
    _updateCart();
  }

  void _updateCart() {
    final double total = _cartItems.fold(0, (sum, item) => sum + item.subtotal);
    emit(SaleLoaded(List.from(_cartItems), total));
  }
}
