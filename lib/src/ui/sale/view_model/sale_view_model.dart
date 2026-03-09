import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/dependences/service_locator.dart';

class SaleViewModel {
  final SaleBloc bloc = getIt<SaleBloc>();

  void removeProduct(CartItem item) {
    bloc.removeFromCart(item);
  }

  void finishSale() {
    // Lógica para persistir a venda no banco/API
    print("Venda finalizada com sucesso!");
  }
}
