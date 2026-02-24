import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/product_detail/view_model/product_detail_bloc.dart';
import 'package:api_produtos/src/ui/product_detail/view_model/product_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Recuperando via Get_It
      create: (context) =>
          getIt<ProductDetailBloc>()..add(LoadProductDetail(product)),
      child: Scaffold(
        appBar: CustomAppbar(onItemSelected: (id) {}),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          // BuildWhen evita que a tela inteira redesenhe se apenas a quantidade mudar
          buildWhen: (previous, current) =>
              previous.isLoading != current.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ProductDetailViewModel(product: state.product!);
          },
        ),
      ),
    );
  }
}
