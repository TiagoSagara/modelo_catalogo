import 'package:api_produtos/routing/router.dart';
import 'package:api_produtos/src/ui/core/style/theme/app_theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Produtos',
      routerConfig: AppRouter.router,
      theme: AppTheme.lightTheme(context),
    );
  }
}
