import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/routing/routers.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/core/components/product_card.dart';
import 'package:api_produtos/src/ui/search/products/view_model/product_bloc.dart';
import 'package:api_produtos/src/ui/search/products/view_model/list_search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesListPage extends StatefulWidget {
  final String? categorySlug;
  const CategoriesListPage({super.key, this.categorySlug});

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  late ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = getIt<ProductBloc>();
    _loadData();
  }

  @override
  void didUpdateWidget(covariant CategoriesListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categorySlug != widget.categorySlug) {
      _loadData();
    }
  }

  void _loadData() {
    if (widget.categorySlug != null && widget.categorySlug!.isNotEmpty) {
      _productBloc.loadProducts(widget.categorySlug!, isCategory: true);
    } else {
      _productBloc.loadProducts('', isCategory: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productBloc,
      child: Scaffold(
        appBar: CustomAppbar(onItemSelected: (id) {}),
        body: Column(
          children: [
            if (widget.categorySlug != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categoria: ${widget.categorySlug!.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
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
                    if (state.products.isEmpty) {
                      return const Center(
                        child: Text('Nenhum produto encontrado.'),
                      );
                    }
                    return _buildProductGrid(context, state.products);
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

  Widget _buildProductGrid(BuildContext context, List products) {
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
