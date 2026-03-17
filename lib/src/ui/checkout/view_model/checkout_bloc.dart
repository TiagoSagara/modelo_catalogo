import 'package:api_produtos/data/repositories/checkout_repository.dart';
import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/domain/models/sale_model.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ──────────────────────────────── Eventos ─────────────────────────────────────

abstract class CheckoutEvent {}

/// Cliente confirmou o pedido com seu nome/identificação.
class CheckoutFormSubmitted extends CheckoutEvent {
  final String identificacaoCliente;
  CheckoutFormSubmitted({required this.identificacaoCliente});
}

/// Reinicia o fluxo (ex: ao fechar o diálogo).
class CheckoutReset extends CheckoutEvent {}

// ──────────────────────────────── Estados ─────────────────────────────────────

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

/// Venda criada com sucesso — contém a mensagem para WhatsApp e o ID da venda.
class CheckoutReadyToFinish extends CheckoutState {
  final String companyPhone;
  final String orderMessage;
  final int saleId;

  CheckoutReadyToFinish({
    required this.companyPhone,
    required this.orderMessage,
    required this.saleId,
  });
}

class CheckoutError extends CheckoutState {
  final String message;
  CheckoutError(this.message);
}

// ──────────────────────────────── Bloc ────────────────────────────────────────

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository _repository;
  List<CartItem> _cartItems = [];

  CheckoutBloc(this._repository) : super(CheckoutInitial()) {
    on<CheckoutFormSubmitted>(_onFormSubmitted);
    on<CheckoutReset>((_, emit) => emit(CheckoutInitial()));
  }

  /// Deve ser chamado antes de abrir o diálogo para registrar os itens do carrinho.
  void setCartItems(List<CartItem> items) => _cartItems = List.from(items);

  Future<void> _onFormSubmitted(
    CheckoutFormSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      final itens = _cartItems
          .map(
            (item) => SaleItemRequest(
              idProduto: item.product.idPrd,
              quantidade: item.quantity.toDouble(),
              preco: item.product.precoVenda,
              valorDesconto: 0.0,
            ),
          )
          .toList();

      final double valorBruto = _cartItems.fold(
        0.0,
        (sum, i) => sum + i.subtotal,
      );

      final request = SaleRequest(
        valorBruto: valorBruto,
        valorLiquido: valorBruto,
        valorDesconto: 0.0,
        identificacaoCliente: event.identificacaoCliente,
        observacao: 'Pedido via loja virtual',
        itens: itens,
      );

      final sale = await _repository.createSale(request);
      final orderMessage = _buildOrderMessage(sale, event.identificacaoCliente);

      // Número da empresa — ajuste conforme necessidade ou busque da API
      const companyPhone = '5585999999999';

      emit(
        CheckoutReadyToFinish(
          companyPhone: companyPhone,
          orderMessage: orderMessage,
          saleId: sale.idSds,
        ),
      );
    } catch (e) {
      emit(CheckoutError('Erro ao processar pedido. Tente novamente.'));
    }
  }

  /// Monta o texto do pedido para o WhatsApp.
  String _buildOrderMessage(SaleResponse sale, String identificacao) {
    final buffer = StringBuffer();
    buffer.writeln('🛒 *Novo Pedido #${sale.idSds}*');
    buffer.writeln('─────────────────────');
    if (identificacao.isNotEmpty) {
      buffer.writeln('👤 *Cliente:* $identificacao');
    }
    buffer.writeln('─────────────────────');
    buffer.writeln('🧾 *Itens do Pedido:*');

    for (final item in sale.itens) {
      final subtotal = item.preco * item.quantidade;
      buffer.writeln(
        '• ${item.descricaoProduto} '
        'x${item.quantidade.toInt()} = '
        '${PriceFormatter.toReal(subtotal)}',
      );
    }

    buffer.writeln('─────────────────────');
    buffer.writeln('💰 *Total: ${PriceFormatter.toReal(sale.valorLiquido)}*');
    return buffer.toString();
  }
}
