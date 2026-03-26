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

/// Venda criada com sucesso.
/// Carrega a resposta da API e a mensagem pré-montada para o WhatsApp.
class CheckoutSuccess extends CheckoutState {
  final SaleResponse sale;

  /// Mensagem pré-preenchida para o WhatsApp da empresa.
  /// Inclui itens do pedido e instrução para o cliente informar nome/endereço.
  final String whatsappMessage;

  CheckoutSuccess({required this.sale, required this.whatsappMessage});
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

      final message = _buildWhatsappMessage(sale, event.identificacaoCliente);

      emit(CheckoutSuccess(sale: sale, whatsappMessage: message));
    } catch (e) {
      emit(CheckoutError('Erro ao processar pedido. Tente novamente.'));
    }
  }

  String _buildWhatsappMessage(SaleResponse sale, String identificacao) {
    final buffer = StringBuffer();
    buffer.writeln('🛒 *Novo Pedido #${sale.idSds}*');
    buffer.writeln('─────────────────────');
    if (identificacao.isNotEmpty) {
      buffer.writeln('👤 *Identificação:* $identificacao');
    }
    buffer.writeln('─────────────────────');
    buffer.writeln('🧾 *Itens do Pedido:*');

    for (final item in sale.itens) {
      buffer.writeln(
        '• ${item.descricaoProduto} '
        'x${item.quantidade.toInt()} = '
        '${PriceFormatter.toReal(item.valorLiquido)}',
      );
    }

    buffer.writeln('─────────────────────');
    buffer.writeln('💰 *Total: ${PriceFormatter.toReal(sale.valorLiquido)}*');
    buffer.writeln('─────────────────────');
    buffer.writeln('');
    buffer.writeln('Para confirmar a entrega, por favor informe:');
    buffer.writeln('📝 *Nome completo*');
    buffer.write('📍 *Endereço de entrega* (rua, número, bairro, cidade)');

    return buffer.toString();
  }
}
