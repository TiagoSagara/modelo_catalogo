import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:api_produtos/src/ui/core/components/custom_buttons.dart';
import 'package:api_produtos/src/ui/core/components/custom_quantity_buttom.dart';
import 'package:api_produtos/src/ui/core/components/product_image_default.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/core/style/app_dimens.dart';
import 'package:api_produtos/src/ui/product_detail/view_model/product_detail_bloc.dart';
import 'package:api_produtos/src/ui/product_detail/widgets/add_card_popup.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailViewModel extends StatelessWidget {
  final Product product;

  const ProductDetailViewModel({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppDimens.kLargeScreen;
    final layoutDirection = isMobile ? Axis.vertical : Axis.horizontal;
    final imageSize = isMobile ? screenWidth * 0.85 : 329.0;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Flex(
          direction: layoutDirection,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.stretch
              : CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              child: Card(
                child: product.thumbnail.isEmpty
                    ? buildPlaceholder()
                    : Image.network(
                        product.thumbnail,
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            buildPlaceholder(),
                      ),
              ),
            ),

            const SizedBox(width: 20, height: 20),

            SizedBox(
              width: isMobile ? null : 600,
              height: 350,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: azulPadrao,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Divider(color: azulPadrao, thickness: 0.5),

                      Row(
                        children: [
                          Text(
                            'Estoque: ${product.stock}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 18),
                          Text(
                            'Preço unitário: ${PriceFormatter.toReal(product.price)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      BlocSelector<
                        ProductDetailBloc,
                        ProductDetailState,
                        double
                      >(
                        selector: (state) => state.totalPrice,
                        builder: (context, totalPrice) {
                          return Text(
                            'Total: ${PriceFormatter.toReal(totalPrice)}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: azulPadrao,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      if (product.stock <= 0)
                        const Text(
                          'Produto indisponível no momento.',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        )
                      else
                        CustomQuantityButtom(
                          estoque: product.stock,
                          onChanged: (int qty) {
                            context.read<ProductDetailBloc>().add(
                              UpdateQuantity(qty),
                            );
                          },
                        ),

                      const Spacer(),

                      if (product.stock > 0)
                        _buildActionButtons(isMobile, context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile, BuildContext context) {
    final double? buttonWidth = isMobile ? null : 300;

    return Column(
      children: [
        SizedBox(
          width: buttonWidth,
          child: CustomButtons.textButton(
            text: 'Comprar agora',
            onPressed: () {
              // Lógica de compra direta
            },
            icon: Icons.shopping_bag_outlined,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: buttonWidth,
          child: CustomButtons.textButton(
            text: 'Adicionar ao carrinho',
            onPressed: () {
              final currentQty = context
                  .read<ProductDetailBloc>()
                  .state
                  .quantity;
              getIt<SaleBloc>().addToCart(product, quantity: currentQty);

              showAddedToCartPopup(
                context: context,
                productTitle: product.title,
                quantity: currentQty,
                thumbnail: product.thumbnail,
              );
            },
            icon: Icons.add_shopping_cart_rounded,
          ),
        ),
      ],
    );
  }
}
