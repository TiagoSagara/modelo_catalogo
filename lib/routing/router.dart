import 'package:api_produtos/domain/models/categories_model.dart';
import 'package:api_produtos/src/ui/homepage/home_page.dart';
import 'package:api_produtos/src/ui/sale/sale_page.dart';
import 'package:api_produtos/src/ui/search/categories_list_page.dart';
import 'package:api_produtos/src/ui/search/list_search_page.dart';
import 'package:api_produtos/src/ui/product_detail/product_detail_page.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:go_router/go_router.dart';
import 'package:api_produtos/routing/routers.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRouters.home,
    routes: [
      GoRoute(
        path: AppRouters.home,
        builder: (context, state) => const HomePage(),
      ),
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
        path: AppRouters.productGroup,
        builder: (context, state) {
          final category = state.extra as Category;
          return Categories(category: category);
        },
      ),
      GoRoute(
        path: AppRouters.salePage,
        builder: (context, state) => const SalePage(),
      ),
    ],
  );
}
