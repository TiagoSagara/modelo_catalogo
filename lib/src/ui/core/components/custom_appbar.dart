import 'package:api_produtos/src/ui/core/components/product_search.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/core/style/app_dimens.dart';
import 'package:api_produtos/utils/image_list.dart';
import 'package:api_produtos/src/ui/core/components/custom_bottom_appbar.dart';
import 'package:flutter/material.dart' hide BottomAppBar;

typedef SectionSelectedCallback = void Function(String id);

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final SectionSelectedCallback onItemSelected;

  final void Function(String query)? onSearch;

  const CustomAppbar({super.key, required this.onItemSelected, this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(140.0);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double logoSize = screenWidth < AppDimens.kMinScreen ? 60.0 : 85.0;

    return AppBar(
      backgroundColor: lightGreyColor,
      elevation: 5.0,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 100,
      automaticallyImplyLeading: false,

      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Image.asset(
              ImageList.logoMultSistem,
              width: logoSize,
              fit: BoxFit.contain,
            ),
          ),

          Expanded(
            child: onSearch != null
                ? ProductSearch(onSearch: onSearch!)
                : const SizedBox.shrink(),
          ),
        ],
      ),

      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: CustomBottomAppBar(),
      ),
    );
  }
}
