import 'dart:async';
import 'package:flutter/material.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({super.key, required this.onSearch});

  final Function(String) onSearch;

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  final _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        print("1. Componente disparou busca: $query");
        widget.onSearch(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Center(
        child: SizedBox(
          width: 600,
          height: 50,
          child: TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              filled: true,
              fillColor: AppColors.background,
              hintStyle: const TextStyle(color: greyColor),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onSearch(''); // Reseta a busca
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
