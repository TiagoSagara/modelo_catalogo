import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/core/style/small_dimens.dart';
import 'package:flutter/material.dart';

void showAddedToCartPopup({
  required BuildContext context,
  required String productTitle,
  required int quantity,
  required String thumbnail,
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _AddedToCartPopup(
      productTitle: productTitle,
      quantity: quantity,
      thumbnail: thumbnail,
      onDismiss: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

class _AddedToCartPopup extends StatefulWidget {
  final String productTitle;
  final int quantity;
  final String thumbnail;
  final VoidCallback onDismiss;

  const _AddedToCartPopup({
    required this.productTitle,
    required this.quantity,
    required this.thumbnail,
    required this.onDismiss,
  });

  @override
  State<_AddedToCartPopup> createState() => _AddedToCartPopupState();
}

class _AddedToCartPopupState extends State<_AddedToCartPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _progressAnim;

  static const _duration = Duration(seconds: 3);
  static const _animOut = Duration(milliseconds: 320);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration);

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.12, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 1.0, curve: Curves.easeIn),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, -0.6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.12, curve: Curves.easeOutCubic),
          ),
        );

    _progressAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.12, 1.0, curve: Curves.linear),
      ),
    );

    _controller.forward();

    Future.delayed(_duration - _animOut, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.stop();
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double maxAllowedWidth = SaleDimens.popupWidth(context);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxAllowedWidth),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Material(
                  color: Colors.transparent,
                  child: _PopupCard(
                    productTitle: widget.productTitle,
                    quantity: widget.quantity,
                    thumbnail: widget.thumbnail,
                    progressAnim: _progressAnim,
                    onDismiss: _dismiss,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PopupCard extends StatelessWidget {
  final String productTitle;
  final int quantity;
  final String thumbnail;
  final Animation<double> progressAnim;
  final VoidCallback onDismiss;

  const _PopupCard({
    required this.productTitle,
    required this.quantity,
    required this.thumbnail,
    required this.progressAnim,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: azulPadrao.withOpacity(0.13),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 10, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ícone de confirmação
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: verdePadrao.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: verdePadrao,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: thumbnail.isNotEmpty
                          ? Image.network(
                              thumbnail,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const _FallbackImage(),
                            )
                          : const _FallbackImage(),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Adicionado ao carrinho',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: verdePadrao,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          productTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: azulPadrao,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Quantidade: $quantity',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: onDismiss,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),

            AnimatedBuilder(
              animation: progressAnim,
              builder: (_, __) => LinearProgressIndicator(
                value: progressAnim.value,
                minHeight: 3,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  verdePadrao.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 22),
    );
  }
}
