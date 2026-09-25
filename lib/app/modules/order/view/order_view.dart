import 'package:ecom_user_flutter/app/models/ecom/order/order_history_model.dart';
import 'package:ecom_user_flutter/app/modules/order/controller/order_controller.dart';
import 'package:ecom_user_flutter/app/modules/root/controllers/root_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryPage extends GetView<OrderController> {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back to home',
          onPressed: () => Get.find<RootController>().currentIndex.value = 0,
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
        ),
        title: Text(
          'Order History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh orders',
            onPressed: controller.userOrderHistoryController,
            icon: Icon(Icons.refresh_rounded, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.orderHistory.isEmpty) {
          return const _LoadingState();
        }

        if (controller.error.value.isNotEmpty &&
            controller.orderHistory.isEmpty) {
          return _ErrorState(
            message: controller.error.value,
            onRetry: controller.userOrderHistoryController,
          );
        }

        final orders = controller.orderHistory;
        if (orders.isEmpty) {
          return _EmptyState(onRefresh: controller.userOrderHistoryController);
        }

        return RefreshIndicator(
          onRefresh: controller.userOrderHistoryController,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
            itemCount: orders.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _OrderCountHeader(count: orders.length);
              }
              return _OrderCard(item: orders[index - 1]);
            },
          ),
        );
      }),
    );
  }
}

class _OrderCountHeader extends StatelessWidget {
  const _OrderCountHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count ${count == 1 ? 'order' : 'orders'}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Icon(Icons.swipe_down_alt_rounded,
              size: 16, color: AppColors.textMuted),
          const SizedBox(width: 5),
          Text(
            'Pull to refresh',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item});

  final OrderHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shopName = _firstText([
      item.shop?.shopName,
      item.shop?.name,
      item.shopName,
    ]);
    final itemCount = item.totalItems ?? item.items.length;
    final shopId = item.shop?.id ?? item.shopId;
    final status = _statusStyle(item.status);
    final payment = _paymentStyle(item.paymentStatus);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: item.id == null
            ? null
            : () => Get.find<OrderController>().getOrderDetails(item.id),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      color: AppColors.primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.orderNumber ?? 'Order #${item.id ?? '-'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: shopId == null || shopId <= 0
                        ? 'Shop chat unavailable'
                        : 'Chat about this order',
                    onPressed: shopId == null || shopId <= 0
                        ? null
                        : () => _openOrderChat(
                              item: item,
                              shopId: shopId,
                              itemCount: itemCount,
                            ),
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      backgroundColor:
                          AppColors.primaryColor.withValues(alpha: 0.08),
                      disabledForegroundColor: AppColors.textMuted,
                    ),
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                ],
              ),
              const SizedBox(height: 13),
              Divider(height: 1, color: AppColors.dividerColor),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: _OrderMetric(
                      label: 'Placed on',
                      value: _formatDate(item.createdAt),
                    ),
                  ),
                  _MetricDivider(color: AppColors.dividerColor),
                  Expanded(
                    child: _OrderMetric(
                      label: 'Items',
                      value: itemCount.toString(),
                      centered: true,
                    ),
                  ),
                  _MetricDivider(color: AppColors.dividerColor),
                  Expanded(
                    child: _OrderMetric(
                      label: 'Total',
                      value: '৳${_money(item.total)}',
                      alignEnd: true,
                      emphasized: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  _StatusBadge(
                    icon: status.icon,
                    text: status.label,
                    background: status.background,
                    foreground: status.foreground,
                  ),
                  _StatusBadge(
                    icon: payment.icon,
                    text: payment.label,
                    background: payment.background,
                    foreground: payment.foreground,
                  ),
                  if ((item.paymentMethod ?? '').trim().isNotEmpty)
                    _StatusBadge(
                      icon: Icons.payments_outlined,
                      text: _titleCase(item.paymentMethod!),
                      background: AppColors.softCardBackground,
                      foreground: AppColors.textSecondary,
                    ),
                ],
              ),
              if ((item.shippingAddress ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 13),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 17, color: AppColors.textMuted),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        item.shippingAddress!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                          Get.find<OrderController>().getOrderDetails(item.id),
                  icon: const Icon(Icons.receipt_long_outlined, size: 18),
                  label: const Text('View order details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    side: BorderSide(
                      color: AppColors.primaryColor.withValues(alpha: 0.28),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderMetric extends StatelessWidget {
  const _OrderMetric({
    required this.label,
    required this.value,
    this.centered = false,
    this.alignEnd = false,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool centered;
  final bool alignEnd;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final alignment = alignEnd
        ? CrossAxisAlignment.end
        : centered
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: emphasized ? AppColors.primaryColor : AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34, color: color);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.icon,
    required this.text,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
}

_StatusStyle _statusStyle(String? rawStatus) {
  final status = (rawStatus ?? '').trim().toLowerCase();
  switch (status) {
    case 'completed':
    case 'delivered':
      return _StatusStyle(
        label: _titleCase(status),
        icon: Icons.check_circle_outline_rounded,
        background: const Color(0xFFE8F7EE),
        foreground: const Color(0xFF15803D),
      );
    case 'processing':
    case 'confirmed':
      return _StatusStyle(
        label: _titleCase(status),
        icon: Icons.sync_rounded,
        background: const Color(0xFFEAF2FF),
        foreground: const Color(0xFF1D4ED8),
      );
    case 'cancelled':
    case 'canceled':
      return _StatusStyle(
        label: 'Cancelled',
        icon: Icons.cancel_outlined,
        background: const Color(0xFFFFE9E9),
        foreground: const Color(0xFFB91C1C),
      );
    default:
      return _StatusStyle(
        label: status.isEmpty ? 'Pending' : _titleCase(status),
        icon: Icons.schedule_rounded,
        background: const Color(0xFFFFF6E6),
        foreground: const Color(0xFFB45309),
      );
  }
}

_StatusStyle _paymentStyle(String? rawStatus) {
  final status = (rawStatus ?? '').trim().toLowerCase();
  final paid = status == 'paid';
  return _StatusStyle(
    label: status.isEmpty ? 'Unpaid' : _titleCase(status),
    icon: paid ? Icons.verified_outlined : Icons.pending_outlined,
    background: paid ? const Color(0xFFE8F7EE) : const Color(0xFFFFE9E9),
    foreground: paid ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
  );
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 58, color: AppColors.textMuted),
            const SizedBox(height: 14),
            Text(
              'No orders yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your orders will appear here after checkout.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 52, color: AppColors.errorColor),
            const SizedBox(height: 12),
            Text(
              'Could not load orders',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

String _firstText(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return 'Store unavailable';
}

void _openOrderChat({
  required OrderHistoryItem item,
  required int shopId,
  required int itemCount,
}) {
  Get.toNamed(
    Routes.SHOP_CHAT_THREAD,
    arguments: {
      'shop_id': shopId,
      'order_context': {
        'order_id': item.id,
        'order_code': item.orderNumber,
        'total_price': item.total,
        'total_items': itemCount,
      },
    },
  );
}

String _money(double? value) {
  final amount = value ?? 0;
  return amount == amount.roundToDouble()
      ? amount.toInt().toString()
      : amount.toStringAsFixed(2);
}

String _formatDate(String? value) {
  final date = DateTime.tryParse(value ?? '')?.toLocal();
  if (date == null) return '-';
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String _titleCase(String value) {
  final normalized = value.trim().replaceAll('_', ' ');
  if (normalized.isEmpty) return normalized;
  return normalized
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
