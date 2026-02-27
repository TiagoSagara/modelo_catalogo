import 'package:api_produtos/routing/routers.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/core/components/product_card.dart';
import 'package:api_produtos/src/ui/core/components/product_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_produtos/dependences/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'view_model/product_bloc.dart';
import 'view_model/list_search_view_model.dart';

class ListSearchPage extends StatelessWidget {
  final String? categorySlug;
  const ListSearchPage({super.key, this.categorySlug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 1. Criamos o Bloc
      create: (_) {
        final bloc =
            getIt<
              ProductBloc
            >(); // Usando o getIt para pegar a instância configurada

        // Verifica se temos um slug para filtrar por categoria
        bool hasCategory = categorySlug != null && categorySlug!.isNotEmpty;

        bloc.loadProducts(categorySlug ?? "", isCategory: hasCategory);
        return bloc;
      },
      child: Builder(
        builder: (newContext) {
          return Scaffold(
            appBar: CustomAppbar(onItemSelected: (id) {}),
            body: Column(
              children: [
                ProductSearch(
                  onSearch: (query) {
                    // 3. AGORA usamos o newContext. Ele consegue encontrar o ProductBloc!
                    newContext.read<ProductBloc>().loadProducts(
                      query,
                      isCategory: false,
                    );
                  },
                ),
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is ProductError) {
                        return Center(child: Text(state.message));
                      }
                      if (state is ProductLoaded) {
                        return _buildProductGrid(state.products);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth >= 1100
            ? 4
            : (constraints.maxWidth >= 700 ? 3 : 2);

        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: crossAxisCount == 2 ? 0.6 : 0.8,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () =>
                      context.push(AppRouters.productDetail, extra: product),
                  child: CardSearch(product: product),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
