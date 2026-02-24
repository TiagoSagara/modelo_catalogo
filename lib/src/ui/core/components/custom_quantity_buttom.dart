import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:flutter/material.dart';

class CustomQuantityButtom extends StatefulWidget {
  final int estoque;
  final Function(int) onChanged;

  const CustomQuantityButtom({
    super.key,
    required this.estoque,
    required this.onChanged,
  });

  @override
  State<CustomQuantityButtom> createState() => _CustomQuantityButtomState();
}

class _CustomQuantityButtomState extends State<CustomQuantityButtom> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove, color: errorColor),
          onPressed: () {
            if (_quantity > 1) {
              setState(() {
                _quantity--;
              });
              widget.onChanged(_quantity);
            }
          },
        ),
        SizedBox(width: 10),
        Text(
          _quantity.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.add, color: azulPadrao),
          onPressed: () {
            if (_quantity < widget.estoque) {
              setState(() {
                _quantity++;
              });
              widget.onChanged(_quantity);
            }
          },
        ),
      ],
    );
  }
}
