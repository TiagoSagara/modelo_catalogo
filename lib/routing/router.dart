import 'package:api_produtos/src/ui/sale/sale_page.dart';
import 'package:api_produtos/src/ui/search/products/list_search_page.dart';
import 'package:api_produtos/src/ui/search/categories/categories_list_page.dart';
import 'package:api_produtos/src/ui/product_detail/product_detail_page.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:go_router/go_router.dart';
import 'package:api_produtos/routing/routers.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRouters.productList,
    routes: [
      GoRoute(
        path: AppRouters.productList,
        builder: (context, state) => const ListSearchPage(),
      ),
      GoRoute(
        path: AppRouters.productDetail,
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailPage(product: product);
        },
      ),
      GoRoute(
        name: AppRouters.productGroup,
        path: AppRouters.productGroupPath,
        builder: (context, state) {
          // categoryId vem como path parameter (string) → converte para int
          final String? categoryIdStr = state.pathParameters['category'];
          final int? categoryId = int.tryParse(categoryIdStr ?? '');
          // categoryName vem como extra (string opcional)
          final String? categoryName = state.extra as String?;
          return CategoriesListPage(
            categoryId: categoryId,
            categoryName: categoryName,
          );
        },
      ),
      GoRoute(
        path: AppRouters.salePage,
        builder: (context, state) => const SalePage(),
      ),
    ],
  );
}
