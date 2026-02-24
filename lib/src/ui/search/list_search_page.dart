import 'package:api_produtos/routing/router.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/search/widgets/card_search.dart';
import 'package:api_produtos/src/ui/search/widgets/product_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_produtos/dependences/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'view_model/product_bloc.dart';
import 'view_model/list_search_view_model.dart';

class ListSearchPage extends StatelessWidget {
  const ListSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(getIt())..loadProducts(""),
      child: Scaffold(
        appBar: CustomAppbar(onItemSelected: (id) {}),
        body: Column(
          children: [
            const ProductSearch(),
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
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 2;
                        if (constraints.maxWidth >= 1100) {
                          crossAxisCount = 4;
                        } else if (constraints.maxWidth >= 700) {
                          crossAxisCount = 3;
                        }

                        return Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 1100),
                            child: GridView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: state.products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: crossAxisCount == 2
                                        ? 0.6
                                        : 0.8,
                                  ),
                              itemBuilder: (context, index) {
                                final product = state.products[index];
                                return InkWell(
                                  onTap: () {
                                    context.push(
                                      AppRouter.productDetail,
                                      extra: product,
                                    );
                                  },
                                  child: CardSearch(product: product),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
