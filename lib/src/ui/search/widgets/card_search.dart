import 'package:api_produtos/src/ui/core/components/product_image_default.dart';
import 'package:flutter/material.dart';
import 'package:api_produtos/domain/models/product_model.dart';

class CardSearch extends StatelessWidget {
  const CardSearch({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            'R\$ ${product.price}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
