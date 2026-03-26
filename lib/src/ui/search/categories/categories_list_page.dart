import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/core/components/product_card.dart';
import 'package:api_produtos/src/ui/product_detail/widgets/product_detail_bottom_sheet.dart';
import 'package:api_produtos/src/ui/search/products/view_model/product_bloc.dart';
import 'package:api_produtos/src/ui/search/products/view_model/list_search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesListPage extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const CategoriesListPage({super.key, this.categoryId, this.categoryName});

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
    if (oldWidget.categoryId != widget.categoryId) {
      _loadData();
    }
  }

  void _loadData() {
    if (widget.categoryId != null) {
      _productBloc.loadProducts(
        '',
        isCategory: true,
        categoryId: widget.categoryId,
      );
    } else {
      _productBloc.loadProducts('');
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
            if (widget.categoryName != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categoria: ${widget.categoryName!.toUpperCase()}',
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    // Colunas: 2 no mobile, 3 no tablet, 4 no desktop
    final int crossAxisCount = screenWidth >= 900
        ? 4
        : (screenWidth >= 600 ? 3 : 2);

    final double childAspectRatio = isMobile ? 0.62 : 0.78;

    final grid = GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return InkWell(
          onTap: () => showProductDetailBottomSheet(context, product),
          child: CardSearch(product: product),
        );
      },
    );

    // Mobile: grade ocupa toda a largura (comportamento esperado)
    if (isMobile) return grid;

    // Tablet / Desktop: centralizado com largura máxima de 1100 px
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: grid,
      ),
    );
  }
}
