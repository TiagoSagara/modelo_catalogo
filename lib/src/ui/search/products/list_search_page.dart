import 'package:api_produtos/domain/models/product_model.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/core/components/product_card.dart';
import 'package:api_produtos/src/ui/product_detail/widgets/product_detail_bottom_sheet.dart';
import 'package:api_produtos/src/ui/search/products/view_model/list_search_view_model.dart';
import 'package:api_produtos/src/ui/search/products/widgets/store_banner_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:api_produtos/dependences/service_locator.dart';
import 'view_model/product_bloc.dart';

class ListSearchPage extends StatefulWidget {
  final int? categoryId;
  const ListSearchPage({super.key, this.categoryId});

  @override
  State<ListSearchPage> createState() => _ListSearchPageState();
}

class _ListSearchPageState extends State<ListSearchPage> {
  final ScrollController _scrollController = ScrollController();
  late ProductBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ProductBloc>();
    _scrollController.addListener(_onScroll);

    if (widget.categoryId != null) {
      _bloc.loadProducts('', isCategory: true, categoryId: widget.categoryId);
    } else {
      _bloc.loadProducts('');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.categoryId != null) {
        _bloc.loadProducts(
          '',
          isCategory: true,
          categoryId: widget.categoryId,
          isLoadMore: true,
        );
      } else {
        _bloc.loadProducts('', isLoadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: CustomAppbar(
          onItemSelected: (id) {},
          onSearch: (query) {
            _bloc.loadProducts(query, isCategory: false);
          },
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            if (state is ProductLoaded) {
              return _buildSliverLayout(state.products, state.hasReachedMax);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSliverLayout(List<Product> products, bool hasReachedMax) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth >= 1100
            ? 4
            : (constraints.maxWidth >= 700 ? 3 : 2);

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(child: StoreBannerCard()),

            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: crossAxisCount == 2 ? 0.6 : 0.8,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = products[index];
                  return InkWell(
                    onTap: product.stock > 0
                        ? () => showProductDetailBottomSheet(context, product)
                        : null,
                    child: CardSearch(product: product),
                  );
                }, childCount: products.length),
              ),
            ),

            if (!hasReachedMax)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }
}
