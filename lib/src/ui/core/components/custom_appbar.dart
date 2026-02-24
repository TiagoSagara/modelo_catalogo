import 'package:api_produtos/src/ui/core/components/custom_shopping_car.dart';
import 'package:api_produtos/utils/image_list.dart';
import 'package:flutter/material.dart';

typedef SectionSelectedCallback = void Function(String id);

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final SectionSelectedCallback onItemSelected;

  const CustomAppbar({super.key, required this.onItemSelected});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(ImageList.logoMultSistem, width: 50),
      backgroundColor: Colors.white,
      elevation: 3.0,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      actions: [
        ShoppingCar(onPressed: () {}),
        const SizedBox(width: 16),
      ],
    );
  }
}
