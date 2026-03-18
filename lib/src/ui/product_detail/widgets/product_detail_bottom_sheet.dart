import 'package:api_produtos/dependences/service_locator.dart';
import 'package:api_produtos/domain/models/product_model.dart';
import 'package:api_produtos/src/ui/core/components/custom_buttons.dart';
import 'package:api_produtos/src/ui/core/components/custom_quantity_buttom.dart';
import 'package:api_produtos/src/ui/core/components/product_image_default.dart';
import 'package:api_produtos/src/ui/core/style/app_colors.dart';
import 'package:api_produtos/src/ui/product_detail/view_model/product_detail_bloc.dart';
import 'package:api_produtos/src/ui/product_detail/widgets/add_card_popup.dart';
import 'package:api_produtos/src/ui/sale/view_model/sale_bloc.dart';
import 'package:api_produtos/utils/price_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:api_produtos/routing/routers.dart';

/// Exibe os detalhes do produto em um bottom sheet deslizante (de baixo para cima).
/// Substitui a navegação para ProductDetailPage.
Future<void> showProductDetailBottomSheet(
  BuildContext context,
  Product product,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) =>
          getIt<ProductDetailBloc>()..add(LoadProductDetail(product)),
      child: _ProductDetailSheet(product: product),
    ),
  );
}

class _ProductDetailSheet extends StatelessWidget {
  final Product product;
  const _ProductDetailSheet({required this.product});

  @override
  Widget build(BuildContext context) {
    // Ocupa até 92% da altura da tela, mínimo 60%
    final maxHeight = MediaQuery.of(context).size.height * 0.92;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle de arraste ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Cabeçalho com título e botão fechar ──────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: azulPadrao,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // ── Conteúdo scrollável ──────────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _SheetBody(product: product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetBody extends StatelessWidget {
  final Product product;
  const _SheetBody({required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Imagem ───────────────────────────────────────────────────────
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.thumbnail.isEmpty
                ? buildPlaceholder()
                : Image.network(
                    product.thumbnail,
                    height: isWide ? 280 : 220,
                    width: isWide ? 280 : screenWidth * 0.7,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => buildPlaceholder(),
                  ),
          ),
        ),

        const SizedBox(height: 20),

        // ── Informações: estoque e preço unitário ────────────────────────
        Row(
          children: [
            _InfoChip(
              icon: Icons.inventory_2_outlined,
              label: 'Estoque: ${product.stock}',
              color: product.stock > 0 ? verdePadrao : errorColor,
            ),
            const SizedBox(width: 10),
            _InfoChip(
              icon: Icons.sell_outlined,
              label: PriceFormatter.toReal(product.price),
              color: azulPadrao,
            ),
          ],
        ),

        if (product.aplicacao.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Aplicação: ${product.aplicacao}',
            style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
          ),
        ],

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFEEEEEE)),
        const SizedBox(height: 16),

        // ── Total calculado ──────────────────────────────────────────────
        BlocSelector<ProductDetailBloc, ProductDetailState, double>(
          selector: (state) => state.totalPrice,
          builder: (context, totalPrice) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              Text(
                PriceFormatter.toReal(totalPrice),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: azulPadrao,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Seletor de quantidade ou aviso de indisponível ───────────────
        if (product.stock <= 0)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Produto indisponível no momento.',
              style: TextStyle(fontSize: 16, color: errorColor),
            ),
          )
        else
          CustomQuantityButtom(
            estoque: product.stock,
            onChanged: (int qty) {
              context.read<ProductDetailBloc>().add(UpdateQuantity(qty));
            },
          ),

        const SizedBox(height: 24),

        // ── Botões de ação ───────────────────────────────────────────────
        if (product.stock > 0) _ActionButtons(product: product),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Product product;
  const _ActionButtons({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Comprar agora: adiciona ao carrinho e navega para o carrinho
        CustomButtons.textButton(
          text: 'Comprar agora',
          icon: Icons.shopping_bag_outlined,
          onPressed: () {
            final qty = context.read<ProductDetailBloc>().state.quantity;
            getIt<SaleBloc>().addToCart(product, quantity: qty);
            Navigator.of(context).pop(); // fecha o bottom sheet
            context.push(AppRouters.salePage);
          },
        ),

        const SizedBox(height: 8),

        // Adicionar ao carrinho: adiciona e exibe popup de confirmação
        CustomButtons.textButton(
          text: 'Adicionar ao carrinho',
          icon: Icons.add_shopping_cart_rounded,
          onPressed: () {
            final qty = context.read<ProductDetailBloc>().state.quantity;
            getIt<SaleBloc>().addToCart(product, quantity: qty);
            Navigator.of(context).pop(); // fecha o bottom sheet
            showAddedToCartPopup(
              context: context,
              productTitle: product.title,
              quantity: qty,
              thumbnail: product.thumbnail,
            );
          },
        ),
      ],
    );
  }
}

/// Chip de informação reutilizável (estoque, preço).
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
