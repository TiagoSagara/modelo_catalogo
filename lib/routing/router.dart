import 'package:api_produtos/src/ui/homepage/home_page.dart';
import 'package:api_produtos/src/ui/search/list_search_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String productList = '/produtos';

  static final router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(path: home, builder: (context, state) => const HomePage()),
      GoRoute(path: productList, builder: (context, state) => ListSearchPage()),
    ],
  );
}
