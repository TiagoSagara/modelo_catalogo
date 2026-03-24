import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/domain/models/categories_bottom_appbar_bloc.dart';
import 'package:api_produtos/domain/models/categories_model.dart';
import 'package:api_produtos/routing/routers.dart';
import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/src/ui/core/components/custom_shopping_car.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
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
  bool _isDropdownHovered = false;

  @override
  Widget build(BuildContext context) {
    const Color hoverColor = Color(0xFFEEEEEE);
    const double borderRadius = 8.0;

    return BlocProvider(
      create: (_) => getIt<CategoryBloc>()..fetchCategories(),
      child: Container(
        color: Colors.transparent,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
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

                    List<CategoryModel> items = [];
                    if (state is CategoryLoaded) {
                      items = state.categories;
                    }

                    return DropdownButton<int>(
                      isExpanded: true,
                      hint: const Text(
                        'Categorias',
                        style: TextStyle(
                          color: azulPadrao,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(borderRadius),
                      items: items.map((CategoryModel category) {
                        return DropdownMenuItem<int>(
                          value: category.idGrp,
                          child: Text(
                            category.nome,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (int? selectedCategoryId) {
                        if (selectedCategoryId != null) {
                          final cat = items.firstWhere(
                            (c) => c.idGrp == selectedCategoryId,
                          );
                          context.pushNamed(
                            AppRouters.productGroup,
                            pathParameters: {
                              'category': selectedCategoryId.toString(),
                            },
                            extra: cat.nome,
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
                'Produtos',
                style: TextStyle(
                  color: azulPadrao,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.push(AppRouters.salePage),
              child: const Text(
                'Promoções',
                style: TextStyle(
                  color: azulPadrao,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<SaleBloc, SaleState>(
                  builder: (context, state) {
                    int count = 0;
                    if (state is SaleLoaded) {
                      count = state.products.fold(0, (sum, item) => sum + item.quantity);
                    }
                    return ShoppingCar(itemCount: count);
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
