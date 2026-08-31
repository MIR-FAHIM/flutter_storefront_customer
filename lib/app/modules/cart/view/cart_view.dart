// lib/app/modules/cart/views/cart_view.dart

import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/models/ecom/order/cart_model.dart';
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/modules/root/controllers/root_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/routes/store_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  static const Color _navy = Color(0xFF1F214C);
  static const Color _bg = Color(0xFFF7F8FA);
  static const Color _softBeige = Color(0xFFFFF3DF);
  static const Color _line = Color(0xFFE9EAF0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () {
            Get.find<RootController>().currentIndex.value = 0;
            offToStoreHomeOrRoot();
          },
        ),
        title: Text(
          'Shopping Cart',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: _navy,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Obx(() {
        final cart = controller.cart.value;
        final items = cart?.items ?? const <CartItem>[];
        final hasItems = items.isNotEmpty;
        final total = controller.totalAmount.value;

        return _CartBottomBar(
          total: total,
          enabled: hasItems,
          onCheckout: () => controller.goToCheckout(),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const _PageLoader();
        }

        if (controller.error.value.isNotEmpty) {
          return _ErrorState(
            message: controller.error.value,
            onRetry: () => controller.getActiveCart(reset: true),
          );
        }

        final cart = controller.cart.value;
        final items = cart?.items ?? const <CartItem>[];

        if (cart == null || items.isEmpty) {
          return _EmptyState(
            onShopNow: () {
              Get.find<RootController>().currentIndex.value = 0;
              offToStoreHomeOrRoot();
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.getActiveCart(reset: true);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: _CartSummaryCard(
                    itemCount: items.length,
                    total: controller.totalAmount.value,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: _SectionHeader(
                    title: 'Cart items',
                    trailing: '${items.length} item${items.length == 1 ? '' : 's'}',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index.isOdd) return const SizedBox(height: 12);
                      final itemIndex = index ~/ 2;
                      final item = items[itemIndex];
                      return _CartItemCard(
                        key: ValueKey(_itemKey(item, itemIndex)),
                        item: item,
                        index: itemIndex,
                      );
                    },
                    childCount: items.length * 2 - 1,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CartSummaryCard extends StatelessWidget {
  const _CartSummaryCard({required this.itemCount, required this.total});

  final int itemCount;
  final num total;

  static const Color _navy = CartView._navy;
  static const Color _softBeige = CartView._softBeige;
  static const Color _line = CartView._line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _softBeige,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: _navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your order summary',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$itemCount item${itemCount == 1 ? '' : 's'} ready for checkout',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _money(total),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: _navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black45,
            ),
          ),
      ],
    );
  }
}

class _CartItemCard extends GetView<CartController> {
  const _CartItemCard({super.key, required this.item, required this.index});

  final CartItem item;
  final int index;

  static const Color _navy = CartView._navy;
  static const Color _line = CartView._line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = item.product;
    final title = product?.name ?? 'Product';
    final price = item.unitPrice ?? product?.unitPrice ?? 0;
    final qty = item.qty ?? 0;
    final imgUrl = _asImageUrl(product?.primaryImage?.fileName);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.045),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: _heroTag(item, index),
              child: _ProductImage(url: imgUrl, size: 88),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _money(price),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _QtyStepper(
                        qty: qty,
                        onMinus: () => controller.decreaseQty(item),
                        onPlus: () => controller.increaseQty(item),
                      ),
                      const Spacer(),
                      _DeleteButton(onTap: () => controller.removeItem(item)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.qty, required this.onMinus, required this.onPlus});

  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  static const Color _navy = CartView._navy;
  static const Color _line = CartView._line;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SmallRoundButton(icon: Icons.remove_rounded, onTap: onMinus),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: SizedBox(
              key: ValueKey(qty),
              width: 34,
              child: Text(
                '$qty',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: _navy,
                ),
              ),
            ),
          ),
          _SmallRoundButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _SmallRoundButton extends StatelessWidget {
  const _SmallRoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: SizedBox(
        width: 34,
        height: 34,
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({required this.total, required this.enabled, required this.onCheckout});

  final num total;
  final bool enabled;
  final VoidCallback onCheckout;

  static const Color _navy = CartView._navy;
  static const Color _softBeige = CartView._softBeige;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, -8),
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _softBeige,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    'Total Amount',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      _money(total),
                      key: ValueKey(total),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: _navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _navy,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: enabled ? onCheckout : null,
                child: const Text(
                  'Proceed To Shipping',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url, required this.size});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: size,
        height: size,
        color: Colors.grey.shade100,
        child: url.isEmpty
            ? const Icon(Icons.image_outlined, color: Colors.black38, size: 34)
            : Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (_, __, ___) => const Icon(
            Icons.broken_image_outlined,
            color: Colors.black38,
            size: 34,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onShopNow});

  final VoidCallback onShopNow;

  static const Color _navy = CartView._navy;
  static const Color _line = CartView._line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _line),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 58, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'Your cart is empty',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Add products to continue your order.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onShopNow,
                child: const Text('Continue Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  static const Color _navy = CartView._navy;
  static const Color _line = CartView._line;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _line),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 42),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black87),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onRetry,
                child: const Text('Retry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageLoader extends StatelessWidget {
  const _PageLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

String _money(num? value) {
  return '৳${(value ?? 0).toStringAsFixed(2)}';
}

String _asImageUrl(String? fileName) {
  if (fileName == null || fileName.trim().isEmpty) return '';
  if (fileName.startsWith('http')) return fileName;
  return '${CompanyData.image_file_url}/$fileName';
}

String _heroTag(CartItem item, int index) {
  final product = item.product;
  final raw = product?.primaryImage?.fileName ?? product?.name ?? index.toString();
  return 'cart_product_image_$raw';
}

String _itemKey(CartItem item, int index) {
  final product = item.product;
  return product?.primaryImage?.fileName ?? product?.name ?? index.toString();
}
