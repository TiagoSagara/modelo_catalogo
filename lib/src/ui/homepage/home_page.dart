import 'package:api_produtos/src/ui/core/components/custom_appbar.dart';
import 'package:api_produtos/src/ui/homepage/widgets/lista_produtos_view_model.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onItemSelected: (id) {}),
      body: ListaProdutosViewModel().body(context),
    );
  }
}
