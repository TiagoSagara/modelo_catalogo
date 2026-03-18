import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/src/ui/core/components/custom_buttons.dart';
import 'package:api_produtos/src/ui/core/components/product_image_default.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/product_detail/widgets/add_card_popup.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:api_produtos/domain/models/product_model.dart';

class CardSearch extends StatelessWidget {
  const CardSearch({super.key, required this.product, this.showBadge = false});

  final Product product;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Card(
            borderOnForeground: true,
            elevation: 5,
            shadowColor: blackColor,
            shape: Border.all(
              color: showBadge ? errorColor : Colors.transparent,
              width: 2,
            ),
            child: product.thumbnail.isEmpty
                ? buildPlaceholder()
                : Image.network(
                    product.thumbnail,
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return buildPlaceholder();
                    },
                  ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    PriceFormatter.toReal(product.price),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                ),
                CustomButtons.textButton(
                  text: '',
                  icon: Icons.add_shopping_cart_rounded,
                  onPressed: () {
                    getIt<SaleBloc>().addToCart(product, quantity: 1);
                    showAddedToCartPopup(
                      context: context,
                      productTitle: product.title,
                      quantity: 1,
                      thumbnail: product.thumbnail,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
