import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class ShoppingCar extends StatelessWidget {
  final Function() onPressed;
  const ShoppingCar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      icon: const Icon(Icons.shopping_cart_rounded, color: verdePadrao),
      onPressed: onPressed,
    );
  }
}
