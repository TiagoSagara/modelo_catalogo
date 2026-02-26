import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppbar(onItemSelected: (id) {}));
  }
}
