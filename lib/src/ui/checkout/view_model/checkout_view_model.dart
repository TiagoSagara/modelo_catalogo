import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/domain/models/checkout_model.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_bloc.dart';

class CheckoutViewModel {
  final CheckoutBloc bloc = getIt<CheckoutBloc>();

  /// Registra os itens do carrinho e abre o fluxo de checkout.
  void setCartItems(List<CartItem> items) => bloc.setCartItems(items);

  /// Envia o formulário completo (nome + CPF + endereço).
  void submitForm({
    required String name,
    required String cpf,
    required AddressModel address,
  }) {
    bloc.add(CheckoutFormSubmitted(name: name, cpf: cpf, address: address));
  }

  /// Reseta o estado ao fechar o diálogo.
  void reset() => bloc.add(CheckoutReset());
}
