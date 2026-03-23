import 'package:api_produtos/src/ui/core/components/product_search.dart';
import 'package:api_produtos/src/ui/core/components/custom_bottom_appbar.dart';
import 'package:flutter/material.dart' hide BottomAppBar;

typedef SectionSelectedCallback = void Function(String id);

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final SectionSelectedCallback onItemSelected;
  final void Function(String query)? onSearch;

  const CustomAppbar({super.key, required this.onItemSelected, this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(136.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 88,
      automaticallyImplyLeading: false,
      flexibleSpace: _AppBarShadow(),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
        child: onSearch != null
            ? ProductSearch(onSearch: onSearch!)
            : const SizedBox.shrink(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: const Color(0xFFE8ECF0), width: 1),
            ),
          ),
          child: const CustomBottomAppBar(),
        ),
      ),
    );
  }
}

class _AppBarShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A2B4A).withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF1A2B4A).withOpacity(0.03),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
