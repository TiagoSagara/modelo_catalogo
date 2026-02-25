import 'package:api_produtos/src/ui/core/components/custom_shopping_car.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/utils/image_list.dart';
import 'package:api_produtos/src/ui/core/components/bottom_appbar.dart';
import 'package:flutter/material.dart' hide BottomAppBar;

typedef SectionSelectedCallback = void Function(String id);

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final SectionSelectedCallback onItemSelected;

  const CustomAppbar({super.key, required this.onItemSelected});

  @override
  Size get preferredSize => const Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: lightGreyColor,
      elevation: 5.0,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 90,
      flexibleSpace: SafeArea(
        child: Center(child: Image.asset(ImageList.logoMultSistem, width: 90)),
      ),
      actions: [
        ShoppingCar(onPressed: () {}),
        const SizedBox(width: 16),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: BottomAppBar(),
      ),
    );
  }
}
