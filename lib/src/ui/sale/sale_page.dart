import 'package:api_produtos/src/ui/checkout/checkout_dialog.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/src/ui/core/style/small_dimens.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_view_model.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final viewModel = SaleViewModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel.bloc,
      child: Scaffold(
        appBar: CustomAppbar(onItemSelected: (id) {}),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
            child: SizedBox(
              width: SaleDimens.width(context),
              child: Card(
                child: BlocBuilder<SaleBloc, SaleState>(
                  builder: (context, state) {
                    if (state is SaleLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is SaleLoaded) {
                      return Column(
                        children: [
                          _buildHeader(),
                          Expanded(
                            child: state.products.isEmpty
                                ? _buildEmptyState()
                                : _buildProductList(state),
                          ),
                          _buildFooter(state, context),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Seu carrinho está vazio',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, top: 20.0),
        child: Text(
          'Meu carrinho',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: verdePadrao,
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(SaleLoaded state) {
    return ListView.builder(
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        final item = state.products[index];
        return ListTile(
          isThreeLine: true,
          leading: Image.network(
            item.product.thumbnail,
            width: 60,
            errorBuilder: (_, __, ___) => const Icon(Icons.image),
          ),
          title: Text(
            item.product.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantidade: ${item.quantity}'),
              Text(
                'Valor unitário: ${PriceFormatter.toReal(item.product.price)}',
              ),
              Text(
                'Subtotal: ${PriceFormatter.toReal(item.subtotal)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: errorColor),
            onPressed: () => viewModel.removeProduct(item),
          ),
        );
      },
    );
  }

  Widget _buildFooter(SaleLoaded state, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total de itens: ${state.products.length}'),
              Text(
                'Total: ${PriceFormatter.toReal(state.totalValue)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: verdePadrao,
                minimumSize: Size(SaleDimens.buttonWidth(context), 50),
              ),
              onPressed: state.products.isEmpty
                  ? null
                  : () => showCheckoutDialog(
                      context: context,
                      cartItems: state.products,
                    ),
              child: const Text(
                'FINALIZAR COMPRA',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
