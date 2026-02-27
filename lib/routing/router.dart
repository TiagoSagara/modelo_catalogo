import 'package:api_produtos/src/ui/homepage/home_page.dart';
import 'package:api_produtos/src/ui/sale/sale_page.dart';
import 'package:api_produtos/src/ui/search/products/list_search_page.dart';
import 'package:api_produtos/src/ui/search/categories/categories_list_page.dart';
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
        name: AppRouters.productGroup, // ✅ Adicionado o nome da rota
        path: AppRouters.productGroupPath, // ✅ Usando o path com parâmetro
        builder: (context, state) {
          final String? categorySlug = state.pathParameters['category'];
          return CategoriesListPage(categorySlug: categorySlug);
        },
      ),
      GoRoute(
        path: AppRouters.salePage,
        builder: (context, state) => const SalePage(),
      ),
    ],
  );
}
