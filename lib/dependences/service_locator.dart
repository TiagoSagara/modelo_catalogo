import 'package:api_produtos/data/repositories/categories_repository.dart';
import 'package:api_produtos/data/repositories/produtos_repository.dart';
import 'package:api_produtos/data/services/categories_service.dart';
import 'package:api_produtos/data/services/produtos_service.dart';
import 'package:api_produtos/domain/models/categories_bottom_appbar_bloc.dart';
import 'package:api_produtos/src/ui/product_detail/view_model/product_detail_bloc.dart';
import 'package:api_produtos/src/ui/search/view_model/product_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Cliente HTTP
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Services
  getIt.registerLazySingleton<ProductService>(
    () => ProductService(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<ProductService>()),
  );

  // Blocs / ViewModels (Factory pois queremos uma nova instância ao entrar na tela)
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getIt<ProductRepository>()),
  );

  getIt.registerFactory<ProductDetailBloc>(() => ProductDetailBloc());

  getIt.registerLazySingleton<CategoryListService>(
    () => CategoryListService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CategorySelectProductService>(
    () => CategorySelectProductService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CategoryProductsService>(
    () => CategoryProductsService(getIt<Dio>()),
  );

  // Repository Categorias
  getIt.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepository(
      getIt<CategoryListService>(),
      getIt<CategoryProductsService>(),
      getIt<CategorySelectProductService>(),
    ),
  );

  // Bloc Categorias
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(getIt<CategoriesRepository>()),
  );
}
