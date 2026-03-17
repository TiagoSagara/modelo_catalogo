import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_bloc.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_view_model.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      listener: (context, state) async {
        if (state is CheckoutReadyToFinish) {
          Navigator.of(context).pop();

          await openWhatsApp(
            phoneRaw: state.companyPhone,
            message: state.orderMessage,
            onError: (msg) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg), backgroundColor: errorColor),
                );
              }
            },
          );
        }

        if (state is CheckoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: errorColor),
          );
        }
      },
      builder: (context, state) {
        if (state is CheckoutLoading) return const _LoadingDialog();
        return _OrderForm(viewModel: viewModel);
      },
    );
  }
}

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
