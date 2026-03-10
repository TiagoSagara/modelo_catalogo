import 'package:api_produtos/data/repositories/checkout_repository.dart';
import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/domain/models/checkout_model.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ──────────────────────────────── Eventos ─────────────────────────────────────

abstract class CheckoutEvent {}

/// Cliente preencheu nome, CPF e endereço → registra e prepara WhatsApp.
class CheckoutFormSubmitted extends CheckoutEvent {
  final String name;
  final String cpf;
  final AddressModel address;

  CheckoutFormSubmitted({
    required this.name,
    required this.cpf,
    required this.address,
  });
}

/// Reinicia o fluxo (ex: ao fechar o diálogo).
class CheckoutReset extends CheckoutEvent {}

// ──────────────────────────────── Estados ─────────────────────────────────────

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

/// Tudo pronto: a view chama openWhatsApp(phone, message) de functions.dart.
/// O Bloc é responsável apenas por buscar o número e montar a mensagem —
/// NÃO por construir URLs nem abrir aplicativos (responsabilidade da view).
class CheckoutReadyToFinish extends CheckoutState {
  final String companyPhone;
  final String orderMessage;

  CheckoutReadyToFinish({
    required this.companyPhone,
    required this.orderMessage,
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
      final customer = CustomerModel(
        name: event.name,
        cpf: event.cpf,
        address: event.address,
      );

      await _repository.registerCustomer(customer);

      final companyPhone = await _repository.getCompanyWhatsApp();
      final orderMessage = _buildOrderMessage(customer);

      emit(
        CheckoutReadyToFinish(
          companyPhone: companyPhone,
          orderMessage: orderMessage,
        ),
      );
    } catch (e) {
      emit(CheckoutError('Erro ao processar pedido. Tente novamente.'));
    }
  }

  /// Monta o texto do pedido para o WhatsApp.
  /// Utiliza formatCurrencyBR implicitamente via toStringAsFixed
  /// (formatação final fica no utils/price_formatter.dart do projeto).
  String _buildOrderMessage(CustomerModel customer) {
    final buffer = StringBuffer();
    buffer.writeln('🛒 *Novo Pedido*');
    buffer.writeln('─────────────────────');
    buffer.writeln('👤 *Cliente:* ${customer.name}');
    buffer.writeln('📋 *CPF:* ${customer.cpf}');
    buffer.writeln('📍 *Endereço:* ${customer.address.formatted}');
    buffer.writeln('─────────────────────');
    buffer.writeln('🧾 *Itens do Pedido:*');

    double total = 0;
    for (final item in _cartItems) {
      total += item.subtotal;
      buffer.writeln(
        '• ${item.product.title} '
        'x${item.quantity} = '
        '${PriceFormatter.toReal(item.subtotal)} ',
      );
    }

    buffer.writeln('─────────────────────');
    buffer.writeln('💰 *Total:  ${PriceFormatter.toReal(total)}*');
    return buffer.toString();
  }
}
