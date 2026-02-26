import 'package:api_produtos/src/ui/core/components/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:api_produtos/routing/routers.dart';

class ListaProdutosViewModel {
  // Adicione o BuildContext como parâmetro no método body
  Widget body(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        child: SizedBox(
          height: 250,
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButtons.textButton(
                text: 'Listar todos os produtos',
                onPressed: () {
                  // Agora o context é válido e pertence à árvore do GoRouter
                  context.push(AppRouters.productList);
                },
              ),
              const Divider(color: Colors.blueGrey, thickness: 1),
              CustomButtons.textButton(
                text: 'Listar produto por ID',
                onPressed: () {
                  // Lógica futura
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
