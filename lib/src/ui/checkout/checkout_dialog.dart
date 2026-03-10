import 'package:api_produtos/domain/models/card_item_model.dart';
import 'package:api_produtos/domain/models/checkout_model.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_bloc.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_view_model.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/utils/functions.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _cpfController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: verdePadrao),
          SizedBox(width: 8),
          Text(
            'Dados para entrega',
            style: TextStyle(color: verdePadrao, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel('Identificação'),
                const SizedBox(height: 8),
                _buildField(
                  controller: _nameController,
                  label: 'Nome completo',
                  icon: Icons.person_outline,
                  validator: requiredIfEmpty,
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _cpfController,
                  label: 'CPF',
                  hint: '000.000.000-00',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  maxLength: 14,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfInputFormatter(),
                  ],
                  validator: (v) => isValidCpf(v ?? '') ? null : 'CPF inválido',
                ),

                const SizedBox(height: 20),

                _sectionLabel('Endereço de entrega'),
                const SizedBox(height: 8),
                _buildField(
                  controller: _streetController,
                  label: 'Rua / Avenida',
                  icon: Icons.signpost_outlined,
                  validator: requiredIfEmpty,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildField(
                        controller: _numberController,
                        label: 'Número',
                        icon: Icons.pin_outlined,
                        keyboardType: TextInputType.number,
                        validator: requiredIfEmpty,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: _buildField(
                        controller: _complementController,
                        label: 'Complemento',
                        icon: Icons.home_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildField(
                  controller: _neighborhoodController,
                  label: 'Bairro',
                  icon: Icons.map_outlined,
                  validator: requiredIfEmpty,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildField(
                        controller: _cityController,
                        label: 'Cidade',
                        icon: Icons.location_city_outlined,
                        validator: requiredIfEmpty,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: _buildField(
                        controller: _stateController,
                        label: 'UF',
                        icon: Icons.flag_outlined,
                        maxLength: 2,
                        textCapitalization: TextCapitalization.characters,
                        validator: (v) =>
                            isValidStateUF(v ?? '') ? null : 'UF inválida',
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
        name: _nameController.text.trim(),
        cpf: _cpfController.text,
        address: AddressModel(
          street: _streetController.text.trim(),
          number: _numberController.text.trim(),
          complement: _complementController.text.trim(),
          neighborhood: _neighborhoodController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim().toUpperCase(),
        ),
      );
    }
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: azulPadrao,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.words,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: materialAzul.shade100),
        ),
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
      ),
      validator: validator,
    );
  }
}
