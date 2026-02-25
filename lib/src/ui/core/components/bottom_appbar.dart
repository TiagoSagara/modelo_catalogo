import 'package:flutter/material.dart';
import 'package:api_produtos/domain/models/list_bottom_appBar.dart';

class BottomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BottomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 50,
      child: Row(
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              ListBottomAppBar.categorias.name,
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              ListBottomAppBar.produtos.name,
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              ListBottomAppBar.promocoes.name,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
