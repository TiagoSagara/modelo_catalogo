import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/routing/router.dart';
import 'package:api_produtos/src/ui/core/style/theme/app_theme.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SaleBloc>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Lista de Produtos',
        routerConfig: AppRouter.router,
        theme: AppTheme.lightTheme(context),
      ),
    );
  }
}
