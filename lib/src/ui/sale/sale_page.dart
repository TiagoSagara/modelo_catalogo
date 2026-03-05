import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_dimens.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SaleBloc>(),
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
                    if (state is SaleInitial || state is SaleLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is SaleLoaded) {
                      return Column(
                        children: [
                          _buildHeader(),
                          Expanded(
                            child: state.products.isEmpty
                                ? const Center(
                                    child: Text("Seu carrinho está vazio"),
                                  )
                                : _buildProductList(state),
                          ),
                          _buildFooter(state),
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

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
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
        final product = state.products[index];
        return ListTile(
          leading: Image.network(
            product.thumbnail ?? '',
            width: 50,
            errorBuilder: (_, __, ___) => Icon(Icons.image),
          ),
          title: Text(product.title ?? ''),
          subtitle: Text(PriceFormatter.toReal(product.price)),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: errorColor),
            onPressed: () => getIt<SaleBloc>().removeFromCart(product),
          ),
        );
      },
    );
  }

  Widget _buildFooter(SaleLoaded state) {
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: verdePadrao,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: state.products.isEmpty
                ? null
                : () {
                    /* Finalizar compra */
                  },
            child: const Text(
              'FINALIZAR COMPRA',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
