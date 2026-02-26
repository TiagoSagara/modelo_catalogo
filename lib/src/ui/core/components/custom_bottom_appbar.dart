import 'package:api_produtos/domain/models/categories_bottom_appbar_bloc.dart';
import 'package:api_produtos/routing/routers.dart';
import 'package:api_produtos/dependences/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomBottomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  // Estado para controlar o hover
  bool _isDropdownHovered = false;

  @override
  Widget build(BuildContext context) {
    // Definimos cores fixas para o exemplo, mas o ideal é usar o Theme
    const Color hoverColor = Color(0xFFEEEEEE); // Cinza muito claro
    const double borderRadius = 8.0;

    return BlocProvider(
      create: (_) => getIt<CategoryBloc>()..add(FetchCategories()),
      child: Container(
        color: Colors.transparent,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // DETECÇÃO DE HOVER NO DROPDAWN
            MouseRegion(
              onEnter: (_) => setState(() => _isDropdownHovered = true),
              onExit: (_) => setState(() => _isDropdownHovered = false),
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 160,
                height: 40,
                decoration: BoxDecoration(
                  color: _isDropdownHovered ? hoverColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ), // Padding interno para os elementos
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    List<String> items = [];
                    if (state is CategoryLoaded) {
                      items = state.categories;
                    }

                    return DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text(
                        "Categorias",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis, // Trunca textos longos
                      ),
                      // Remove a linha padrão de baixo
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      // Estilização do menu que abre
                      borderRadius: BorderRadius.circular(borderRadius),
                      items: items.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category.toLowerCase(),
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? selectedCategory) {
                        if (selectedCategory != null) {
                          context.pushNamed(
                            AppRouters.productGroup,
                            pathParameters: {'category': selectedCategory},
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 8),
            TextButton(
              onPressed: () => context.push(AppRouters.productList),
              child: const Text(
                "Produtos",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRouters.salePage),
              child: const Text(
                "Promoções",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
