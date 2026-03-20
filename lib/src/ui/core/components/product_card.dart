import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/src/ui/core/components/product_image_default.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/product_detail/widgets/add_card_popup.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:api_produtos/domain/models/product_model.dart';

class CardSearch extends StatefulWidget {
  const CardSearch({super.key, required this.product, this.showBadge = false});

  final Product product;
  final bool showBadge;

  @override
  State<CardSearch> createState() => _CardSearchState();
}

class _CardSearchState extends State<CardSearch>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: 2,
      end: 12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovered) {
    setState(() => _isHovered = hovered);
    if (hovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  bool get _outOfStock => widget.product.stock == 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _elevationAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: lightGreyColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.showBadge
                    ? errorColor
                    : _isHovered
                    ? const Color(0xFFD0D7E2)
                    : const Color(0xFFF0F2F5),
                width: widget.showBadge ? 2 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.10 : 0.05),
                  blurRadius: _elevationAnimation.value * 2,
                  offset: Offset(0, _elevationAnimation.value * 0.5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF7F8FA),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: widget.product.thumbnail.isEmpty
                              ? Center(child: buildPlaceholder())
                              : Image.network(
                                  widget.product.thumbnail,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(child: buildPlaceholder()),
                                ),
                        ),

                        if (_outOfStock) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: lightGreyColor.withOpacity(0.55),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4D4D),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Item sem estoque',
                                style: TextStyle(
                                  color: lightGreyColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: azulPadrao,
                              height: 1.35,
                              letterSpacing: -0.1,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Preço',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF8A94A6),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  Text(
                                    PriceFormatter.toReal(widget.product.price),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: azulPadrao,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),

                              _AddToCartButton(
                                outOfStock: _outOfStock,
                                onPressed: () {
                                  getIt<SaleBloc>().addToCart(
                                    widget.product,
                                    quantity: 1,
                                  );
                                  showAddedToCartPopup(
                                    context: context,
                                    productTitle: widget.product.title,
                                    quantity: 1,
                                    thumbnail: widget.product.thumbnail,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddToCartButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool outOfStock;
  const _AddToCartButton({required this.onPressed, required this.outOfStock});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
      lowerBound: 0.88,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.outOfStock) return;
    await _controller.reverse();
    await _controller.forward();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.outOfStock;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handleTap,
        child: Tooltip(
          message: disabled ? 'Produto sem estoque' : '',
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: disabled
                  ? const Color(0xFFD0D5DD)
                  : materialVerde.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              disabled
                  ? Icons.remove_shopping_cart_outlined
                  : Icons.add_shopping_cart_rounded,
              color: disabled ? const Color(0xFF8A94A6) : lightGreyColor,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
