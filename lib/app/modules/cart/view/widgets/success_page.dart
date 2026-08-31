import 'package:ecom_user_flutter/app/models/ecom/order/checkout_success.dart';
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/routes/store_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutSuccessView extends GetView<CartController> {
  const CheckoutSuccessView({super.key});

  static const Color _brand = Color(0xFF00509D);
  static const Color _navy = Color(0xFF151738);
  static const Color _success = Color(0xFF16A34A);
  static const Color _bg = Color(0xFFF5F7FB);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkout = _readCheckoutResponse(Get.arguments);
    final orders = checkout?.data?.orders ?? [];

    if (checkout == null || orders.isEmpty) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(theme),
        body: const _EmptyCheckoutState(),
      );
    }

    final firstOrder = orders.first;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(theme),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SuccessSummaryCard(checkout: checkout),
                const SizedBox(height: 14),
                _CustomerDeliveryCard(order: firstOrder),
                const SizedBox(height: 14),
                _GrandTotalCard(checkout: checkout),
                const SizedBox(height: 14),
                Text(
                  'Order Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  itemCount: orders.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _OrderCard(
                      order: orders[index],
                      orderIndex: index + 1,
                    );
                  },
                ),
                const SizedBox(height: 16),
                const _ActionButtons(),
                const SizedBox(height: 14),
                Text(
                  'You will receive updates about your delivery shortly.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: _brand,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Order Placed',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  CheckoutSuccessResponse? _readCheckoutResponse(dynamic args) {
    try {
      if (args is CheckoutSuccessResponse) {
        return args;
      }

      if (args is Map && args['checkout'] is Map) {
        return CheckoutSuccessResponse.fromJson(
          Map<String, dynamic>.from(args['checkout']),
        );
      }

      if (args is Map && args['status'] != null && args['data'] != null) {
        return CheckoutSuccessResponse.fromJson(
          Map<String, dynamic>.from(args),
        );
      }

      return null;
    } catch (e) {
      debugPrint('CheckoutSuccessResponse parse error: $e');
      return null;
    }
  }
}

class _SuccessSummaryCard extends StatelessWidget {
  const _SuccessSummaryCard({
    required this.checkout,
  });

  final CheckoutSuccessResponse checkout;

  static const Color _brand = Color(0xFF00509D);
  static const Color _navy = Color(0xFF151738);
  static const Color _success = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = checkout.data;
    final firstOrder =
        data?.orders.isNotEmpty == true ? data!.orders.first : null;

    final paymentStatus = firstOrder?.paymentStatus ?? 'unpaid';
    final paymentStatusColor = _statusColor(paymentStatus);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: _success.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              CupertinoIcons.check_mark_circled_solid,
              color: _success,
              size: 58,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Order Confirmed!',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: _navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thank you for your purchase. Your order has been placed successfully.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          if ((data?.paymentGroupId ?? '').isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Payment Group ID',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data!.paymentGroupId,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MiniSummary(
                    label: 'Total Orders',
                    value: checkout.totalOrders.toString(),
                  ),
                ),
                Container(
                  width: 1,
                  height: 38,
                  color: _brand.withOpacity(0.18),
                ),
                Expanded(
                  child: _MiniSummary(
                    label: 'Grand Total',
                    value: _money(checkout.grandTotal),
                    valueColor: _brand,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: paymentStatusColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: paymentStatusColor.withOpacity(0.25)),
            ),
            child: Text(
              'Payment Status: ${_cap(paymentStatus)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: paymentStatusColor,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSummary extends StatelessWidget {
  const _MiniSummary({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF151738),
            fontWeight: FontWeight.w900,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}

class _CustomerDeliveryCard extends StatelessWidget {
  const _CustomerDeliveryCard({
    required this.order,
  });

  final CheckoutSuccessOrder order;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.location_on_outlined,
            title: 'Delivery Information',
          ),
          const SizedBox(height: 10),
          _InfoRow(label: 'Name', value: order.customerName),
          _InfoRow(label: 'Phone', value: order.customerPhone),
          _InfoRow(label: 'Address', value: order.shippingAddress),
          if (order.zoneName.isNotEmpty)
            _InfoRow(label: 'Zone', value: order.zoneName),
          if (order.districtName.isNotEmpty)
            _InfoRow(label: 'District', value: order.districtName),
          if ((order.area ?? '').isNotEmpty)
            _InfoRow(label: 'Area', value: order.area ?? ''),
          if (order.note.isNotEmpty) _InfoRow(label: 'Note', value: order.note),
        ],
      ),
    );
  }
}

class _GrandTotalCard extends StatelessWidget {
  const _GrandTotalCard({
    required this.checkout,
  });

  final CheckoutSuccessResponse checkout;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.receipt_long_outlined,
            title: 'Payment Summary',
          ),
          const SizedBox(height: 10),
          _InfoRow(label: 'Subtotal', value: _money(checkout.grandSubtotal)),
          _InfoRow(
            label: 'Shipping Fee',
            value: _money(checkout.grandShippingFee),
          ),
          _InfoRow(label: 'Discount', value: _money(checkout.grandDiscount)),
          const Divider(height: 18),
          _InfoRow(
            label: 'Grand Total',
            value: _money(checkout.grandTotal),
            isBold: true,
            valueColor: const Color(0xFF00509D),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.orderIndex,
  });

  final CheckoutSuccessOrder order;
  final int orderIndex;

  static const Color _brand = Color(0xFF00509D);
  static const Color _navy = Color(0xFF151738);

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _brand,
                child: Text(
                  orderIndex.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderNumber.isEmpty ? 'N/A' : order.orderNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Order ID: ${order.id}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusChip(
                    text: order.status,
                    color: _statusColor(order.status),
                  ),
                  const SizedBox(height: 5),
                  _StatusChip(
                    text: order.paymentStatus,
                    color: _statusColor(order.paymentStatus),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (order.items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Text(
                'No items found for this order.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            )
          else
            ListView.separated(
              itemCount: order.items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final item = order.items[index];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: _brand,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName.isEmpty
                                ? 'Product'
                                : item.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty ${item.qty} × ${_money(item.unitPrice)}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _money(item.lineTotal),
                      style: const TextStyle(
                        color: _brand,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          const Divider(height: 20),
          _InfoRow(label: 'Subtotal', value: _money(order.subtotal)),
          _InfoRow(label: 'Shipping Fee', value: _money(order.shippingFee)),
          _InfoRow(label: 'Discount', value: _money(order.discount)),
          _InfoRow(
            label: 'Order Total',
            value: _money(order.total),
            isBold: true,
            valueColor: _brand,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00509D),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Get.offNamed(Routes.ORDER_HISTORY);
              },
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text(
                'View My Orders',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                offAllToStoreHomeOrRoot();
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF151738),
              ),
              label: const Text(
                'Continue Shopping',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF151738),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  const _BaseCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 7),
            color: Colors.black.withOpacity(0.035),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF00509D),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF151738),
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = text.trim().isEmpty ? 'N/A' : _cap(text);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.trim().isEmpty ? 'N/A' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: Text(
              safeValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w800,
                color: valueColor ?? const Color(0xFF151738),
                fontSize: isBold ? 13 : 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCheckoutState extends StatelessWidget {
  const _EmptyCheckoutState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 82,
              width: 82,
              decoration: BoxDecoration(
                color: const Color(0xFF00509D).withOpacity(0.08),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Color(0xFF00509D),
                size: 42,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Order information not found.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your order history for the latest order status.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                offAllToStoreHomeOrRoot();
              },
              child: const Text(
                'Back to Home',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _money(num value) {
  if (value % 1 == 0) {
    return '৳${value.toInt()}';
  }

  return '৳${value.toStringAsFixed(2)}';
}

String _cap(String value) {
  final text = value.trim();

  if (text.isEmpty) return 'N/A';

  return text.split('_').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

Color _statusColor(String status) {
  final value = status.toLowerCase().trim();

  if (value == 'success' || value == 'paid' || value == 'completed') {
    return const Color(0xFF16A34A);
  }

  if (value == 'pending' || value == 'processing') {
    return Colors.orange;
  }

  if (value == 'unpaid' || value == 'failed' || value == 'cancelled') {
    return Colors.redAccent;
  }

  return const Color(0xFF00509D);
}
