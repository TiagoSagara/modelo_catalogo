import 'package:api_produtos/src/ui/core/components/custom_shopping_car.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/core/style/app_dimens.dart';
import 'package:api_produtos/utils/image_list.dart';
import 'package:api_produtos/src/ui/core/components/custom_bottom_appbar.dart';
import 'package:flutter/material.dart' hide BottomAppBar;

typedef SectionSelectedCallback = void Function(String id);

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final SectionSelectedCallback onItemSelected;

  const CustomAppbar({super.key, required this.onItemSelected});

  @override
  Size get preferredSize => const Size.fromHeight(140.0);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double logoSize = screenWidth < AppDimens.kMinScreen ? 60.0 : 90.0;

    return AppBar(
      backgroundColor: lightGreyColor,
      elevation: 5.0,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 90,
      centerTitle: true,

      title: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child: Image.asset(
          ImageList.logoMultSistem,
          width: logoSize,
          fit: BoxFit.contain,
        ),
      ),

      actions: [ShoppingCar(), const SizedBox(width: 16)],

      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomBottomAppBar(),
      ),
    );
  }
}
