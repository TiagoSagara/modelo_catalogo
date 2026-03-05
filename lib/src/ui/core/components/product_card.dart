import 'package:api_produtos/src/ui/core/components/product_image_default.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:api_produtos/domain/models/product_model.dart';

class CardSearch extends StatelessWidget {
  const CardSearch({super.key, required this.product, this.promotion = true});

  final Product product;
  final bool promotion;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      elevation: 5,
      shadowColor: blackColor,
      shape: Border.all(
        color: promotion ? errorColor : Colors.transparent,
        width: 2,
      ),
      child: Column(
        children: [
          product.thumbnail.isEmpty
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
          Divider(
            color: Colors.blueGrey,
            thickness: 0.2,
            indent: 15,
            endIndent: 15,
          ),
          SizedBox(
            height: 38,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
          Text(
            PriceFormatter.toReal(product.price),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          if (promotion)
            Text(
              'Até: ${product.formattedUpdateDate}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
        ],
      ),
    );
  }
}
