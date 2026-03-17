import 'package:api_produtos/data/config/api_config.dart';
import 'package:api_produtos/data/repositories/categories_repository.dart';
import 'package:api_produtos/data/repositories/checkout_repository.dart';
import 'package:api_produtos/data/repositories/produtos_repository.dart';
import 'package:api_produtos/data/services/auth_interceptor.dart';
import 'package:api_produtos/data/services/auth_service.dart';
import 'package:api_produtos/data/services/categories_service.dart';
import 'package:api_produtos/data/services/checkout_service.dart';
import 'package:api_produtos/data/services/produtos_service.dart';
import 'package:api_produtos/domain/models/categories_bottom_appbar_bloc.dart';
import 'package:api_produtos/src/ui/checkout/view_model/checkout_bloc.dart';
import 'package:api_produtos/src/ui/product_detail/view_model/product_detail_bloc.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/src/ui/search/products/view_model/product_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // ── Cliente HTTP ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    // Injeta o interceptor de autenticação após o AuthService estar registrado
    dio.interceptors.add(getIt<AuthInterceptor>());
    return dio;
  });

  // ── Auth ────────────────────────────────────────────────────────────────────
  // AuthService usa um Dio limpo (sem o interceptor que dependeria dele mesmo)
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(Dio()),
  );
  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(getIt<AuthService>()),
  );

  // ── Services ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProductService>(
    () => ProductService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CheckoutService>(
    () => CheckoutService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CategoryService>(
    () => CategoryService(getIt<Dio>()),
  );

  // ── Repositories ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<ProductService>()),
  );
  getIt.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepository(getIt<CheckoutService>()),
  );
  getIt.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepository(
      getIt<CategoryService>(),
      getIt<ProductRepository>(),
    ),
  );

  // ── Blocs ───────────────────────────────────────────────────────────────────

  // Factory: nova instância ao entrar na tela
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getIt<ProductRepository>(), getIt<CategoriesRepository>()),
  );
  getIt.registerFactory<ProductDetailBloc>(() => ProductDetailBloc());
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(getIt<CategoriesRepository>()),
  );

  // Singleton: estado compartilhado (carrinho e checkout vivem durante toda a sessão)
  getIt.registerLazySingleton<SaleBloc>(() => SaleBloc());
  getIt.registerLazySingleton<CheckoutBloc>(
    () => CheckoutBloc(getIt<CheckoutRepository>()),
  );
}
