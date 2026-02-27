import 'package:api_produtos/routing/routers.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShoppingCar extends StatelessWidget {
  const ShoppingCar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
      child: IconButton.filledTonal(
        icon: const Icon(
          Icons.shopping_cart_rounded,
          color: verdePadrao,
          size: 35,
        ),
        onPressed: () => context.push(AppRouters.salePage),
      ),
    );
  }
}
