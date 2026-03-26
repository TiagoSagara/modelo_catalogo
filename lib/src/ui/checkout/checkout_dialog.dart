import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/domain/models/sale_model.dart';
import 'package:api_produtos/routing/routers.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_bloc.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_view_model.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

Future<void> showCheckoutDialog({
  required BuildContext context,
  required List<CartItem> cartItems,
}) async {
  final viewModel = CheckoutViewModel()..setCartItems(cartItems);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider.value(
      value: viewModel.bloc,
      child: _CheckoutDialog(viewModel: viewModel),
    ),
  );
}

class _CheckoutDialog extends StatelessWidget {
  final CheckoutViewModel viewModel;
  const _CheckoutDialog({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: errorColor),
          );
        }
      },
      builder: (context, state) {
        if (state is CheckoutLoading) return const _LoadingDialog();
        if (state is CheckoutSuccess) {
          return _SuccessDialog(
            sale: state.sale,
            onFinish: () {
              // Limpa o carrinho e fecha o dialog
              getIt<SaleBloc>().clearCart();
              Navigator.of(context).pop();
              // Navega para a lista de produtos
              context.go(AppRouters.productList);
            },
          );
        }
        return _OrderForm(viewModel: viewModel);
      },
    );
  }
}

// ─────────────────────── Loading ───────────────────────────────────────────────

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: verdePadrao),
            SizedBox(height: 16),
            Text('Processando pedido...'),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Sucesso ───────────────────────────────────────────────

class _SuccessDialog extends StatelessWidget {
  final SaleResponse sale;
  final VoidCallback onFinish;

  const _SuccessDialog({required this.sale, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone de sucesso
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: verdePadrao.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: verdePadrao,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pedido realizado!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: verdePadrao,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pedido #${sale.idSds}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (sale.identificacaoCliente != null &&
                  sale.identificacaoCliente!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Cliente: ${sale.identificacaoCliente}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Lista de itens
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: sale.itens.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final item = sale.itens[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: azulPadrao.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '${item.quantidade.toInt()}x',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: azulPadrao,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.descricaoProduto,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          PriceFormatter.toReal(item.valorLiquido),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    PriceFormatter.toReal(sale.valorLiquido),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: verdePadrao,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botão de concluir
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: verdePadrao,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.storefront_outlined, size: 18),
                  label: const Text(
                    'Continuar comprando',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: onFinish,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────── Formulário ────────────────────────────────────────────

class _OrderForm extends StatefulWidget {
  final CheckoutViewModel viewModel;
  const _OrderForm({required this.viewModel});

  @override
  State<_OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<_OrderForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.shopping_bag_outlined, color: verdePadrao),
          SizedBox(width: 8),
          Text(
            'Finalizar Pedido',
            style: TextStyle(color: verdePadrao, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Identificação',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: azulPadrao,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Seu nome',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: materialAzul.shade100),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.viewModel.reset();
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: verdePadrao,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.send_outlined, size: 18),
          label: const Text('Finalizar'),
          onPressed: _submit,
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.submitForm(
        identificacaoCliente: _nameController.text.trim(),
      );
    }
  }
}
