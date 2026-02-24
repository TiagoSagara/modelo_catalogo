import 'package:api_produtos/domain/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Eventos
abstract class ProductDetailEvent {}

class LoadProductDetail extends ProductDetailEvent {
  final Product product;
  LoadProductDetail(this.product);
}

class UpdateQuantity extends ProductDetailEvent {
  final int quantity;
  UpdateQuantity(this.quantity);
}

// Estado Único e Imutável para Performance
class ProductDetailState {
  final Product? product;
  final int quantity;
  final bool isLoading;

  ProductDetailState({this.product, this.quantity = 1, this.isLoading = true});

  // Getters para lógica de negócio
  double get totalPrice => (product?.price ?? 0.0) * quantity;

  ProductDetailState copyWith({
    Product? product,
    int? quantity,
    bool? isLoading,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailState()) {
    on<LoadProductDetail>((event, emit) {
      emit(state.copyWith(product: event.product, isLoading: false));
    });

    on<UpdateQuantity>((event, emit) {
      emit(state.copyWith(quantity: event.quantity));
    });
  }
}
