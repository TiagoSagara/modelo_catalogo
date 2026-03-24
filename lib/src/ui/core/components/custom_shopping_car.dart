import 'package:api_produtos/routing/routers.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShoppingCar extends StatefulWidget {
  const ShoppingCar({super.key, this.itemCount = 0});

  final int itemCount;

  @override
  State<ShoppingCar> createState() => _ShoppingCarState();
}

class _ShoppingCarState extends State<ShoppingCar>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _hoverController;
  late final AnimationController _blinkController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Color?> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    // Hover Animation
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );

    // Blink Animation
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _blinkAnimation = ColorTween(
      begin: Colors.transparent,
      end: verdePadrao.withValues(alpha: 0.25),
    ).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(covariant ShoppingCar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount > oldWidget.itemCount) {
      _blinkController
          .forward()
          .then((_) => _blinkController.reverse());
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    hovering ? _hoverController.forward() : _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasItems = widget.itemCount > 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () => context.push(AppRouters.salePage),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _blinkAnimation,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _blinkAnimation.value ??
                      (_isHovered
                          ? azulPadrao.withValues(alpha: 0.08)
                          : Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _blinkController.isAnimating
                        ? verdePadrao.withValues(alpha: 0.5)
                        : (_isHovered
                            ? azulPadrao.withValues(alpha: 0.35)
                            : Colors.transparent),
                    width: 1.2,
                  ),
                ),
                child: child,
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  hasItems ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
                  color: _blinkController.isAnimating
                      ? verdePadrao
                      : (_isHovered ? azulPadrao : const Color(0xFF4A4A5A)),
                  size: 22,
                ),
                if (hasItems)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      decoration: const BoxDecoration(
                        color: verdePadrao,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        widget.itemCount > 9 ? '9+' : '${widget.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
