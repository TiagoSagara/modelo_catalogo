import 'package:api_produtos/domain/models/categories_model.dart';
import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  final Category category;
  const Categories({super.key, required this.category});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppbar(onItemSelected: (id) {}));
  }
}
