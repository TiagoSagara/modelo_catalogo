import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_bloc.dart';

class CheckoutViewModel {
  final CheckoutBloc bloc = getIt<CheckoutBloc>();

  /// Registra os itens do carrinho e abre o fluxo de checkout.
  void setCartItems(List<CartItem> items) => bloc.setCartItems(items);

  /// Envia o formulário (somente identificação do cliente).
  void submitForm({required String identificacaoCliente}) {
    bloc.add(CheckoutFormSubmitted(identificacaoCliente: identificacaoCliente));
  }

  /// Reseta o estado ao fechar o diálogo.
  void reset() => bloc.add(CheckoutReset());
}
