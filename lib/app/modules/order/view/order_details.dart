
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/modules/order/controller/order_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/routes/store_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/ecom/order/order_details.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  final OrderController controller = Get.find<OrderController>();

  static const Color _primary = Color(0xFF00509D);
  static const Color _navy = Color(0xFF151738);
  static const Color _yellow = Color(0xFFFEFF00);
  static const Color _bg = Color(0xFFF5F7FB);
  static const Color _border = Color(0xFFE5E7EB);
  static const Color _success = Color(0xFF16A34A);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderId = _readOrderId(Get.arguments);

      if (orderId == null) {
        controller.orderDetailsError.value = 'Order ID not found';
        return;
      }

      controller.getOrderDetails(orderId);
    });
  }

  dynamic _readOrderId(dynamic args) {
    if (args == null) return null;

    if (args is int || args is String) {
      return args;
    }

    if (args is Map) {
      return args['order_id'] ??
          args['id'] ??
          args['orderId'] ??
          args['order_number'];
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isOrderDetailsLoading.value &&
              controller.orderDetails.value == null) {
            return const _OrderDetailsSkeleton();
          }

          if (controller.orderDetailsError.value.isNotEmpty &&
              controller.orderDetails.value == null) {
            return _ErrorState(
              message: controller.orderDetailsError.value,
              onRetry: () {
                final orderId = _readOrderId(Get.arguments);
                if (orderId != null) {
                  controller.getOrderDetails(orderId);
                }
              },
            );
          }

          final order = controller.orderDetails.value;

          if (order == null) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            color: _primary,
            onRefresh: () async {
              await controller.getOrderDetails(order.id);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _OrderHeaderCard(order: order),

                  const SizedBox(height: 12),

                  _StatusTimelineCard(order: order),

                  const SizedBox(height: 12),

                  _DeliveryInfoCard(order: order),

                  const SizedBox(height: 12),

                  if (order.hasDeliveryMan)
                    _DeliveryManCard(order: order),

                  if (order.hasDeliveryMan)
                    const SizedBox(height: 12),

                  _ItemsCard(order: order),

                  const SizedBox(height: 12),

                  _PaymentSummaryCard(order: order),

                  if (order.note.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _NoteCard(note: order.note),
                  ],

                  const SizedBox(height: 18),

                  _BottomActions(order: order),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  const _OrderHeaderCard({
    required this.order,
  });

  final OrderDetailsData order;

  static const Color _primary = Color(0xFF00509D);
  static const Color _navy = Color(0xFF151738);
  static const Color _yellow = Color(0xFFFEFF00);

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: _primary,
              size: 36,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            order.orderNumber,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _navy,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatusChip(
                text: order.status,
                color: _statusColor(order.status),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                text: order.paymentStatus,
                color: _paymentColor(order.paymentStatus),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Amount',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  _money(order.total),
                  style: const TextStyle(
                    color: _yellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          _InfoRow(
            label: 'Created At',
            value: _date(order.createdAt),
          ),
          _InfoRow(
            label: 'Updated At',
            value: _date(order.updatedAt),
          ),
        ],
      ),
    );
  }
}

class _StatusTimelineCard extends StatelessWidget {
  const _StatusTimelineCard({
    required this.order,
  });

  final OrderDetailsData order;

  static const Color _primary = Color(0xFF00509D);
  static const Color _success = Color(0xFF16A34A);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final currentStep = _statusStep(order.status);

    final steps = [
      _TimelineStepData('Pending', Icons.access_time_rounded),
      _TimelineStepData('Confirmed', Icons.verified_outlined),
      _TimelineStepData('Processing', Icons.inventory_2_outlined),
      _TimelineStepData('Shipped', Icons.local_shipping_outlined),
      _TimelineStepData('Delivered', Icons.check_circle_outline_rounded),
    ];

    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.timeline_rounded,
            title: 'Order Status',
          ),

          const SizedBox(height: 14),

          Row(
            children: List.generate(steps.length, (index) {
              final active = index <= currentStep;
              final step = steps[index];

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (index != 0)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: active ? _success : _border,
                            ),
                          ),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: active
                                ? _success.withOpacity(0.12)
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: active ? _success : _border,
                            ),
                          ),
                          child: Icon(
                            step.icon,
                            size: 18,
                            color: active ? _success : Colors.grey,
                          ),
                        ),
                        if (index != steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: index < currentStep ? _success : _border,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      step.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: active ? _primary : Colors.black45,
                        fontWeight: FontWeight.w800,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DeliveryInfoCard extends StatelessWidget {
  const _DeliveryInfoCard({
    required this.order,
  });

  final OrderDetailsData order;

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

          _InfoRow(label: 'Customer', value: order.customerName),
          _InfoRow(label: 'Phone', value: order.customerPhone),
          _InfoRow(label: 'Address', value: order.shippingAddress),
          if (order.zone.isNotEmpty)
            _InfoRow(label: 'Zone', value: order.zone),
          if (order.district != null)
            _InfoRow(label: 'District', value: order.district!),
          if (order.area != null)
            _InfoRow(label: 'Area', value: order.area!),
        ],
      ),
    );
  }
}

class _DeliveryManCard extends StatelessWidget {
  const _DeliveryManCard({
    required this.order,
  });

  final OrderDetailsData order;

  static const Color _primary = Color(0xFF00509D);

  @override
  Widget build(BuildContext context) {
    final assignment = order.deliveryMan;
    final deliveryMan = assignment?.deliveryMan;

    if (assignment == null || deliveryMan == null) {
      return const SizedBox.shrink();
    }

    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.delivery_dining_rounded,
            title: 'Delivery Man',
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: _primary.withOpacity(0.10),
                child: Text(
                  _initials(deliveryMan.name),
                  style: const TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deliveryMan.name,
                      style: const TextStyle(
                        color: Color(0xFF151738),
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deliveryMan.phone.isEmpty
                          ? 'Phone not available'
                          : deliveryMan.phone,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deliveryMan.address.isEmpty
                          ? 'Address not available'
                          : deliveryMan.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              _StatusChip(
                text: assignment.status,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({
    required this.order,
  });

  final OrderDetailsData order;

  static const Color _primary = Color(0xFF00509D);

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.shopping_bag_outlined,
            title: 'Items (${order.items.length})',
          ),

          const SizedBox(height: 12),

          ListView.separated(
            itemCount: order.items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const Divider(height: 18),
            itemBuilder: (context, index) {
              final item = order.items[index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: _primary,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF151738),
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Qty ${item.qty} × ${_money(item.unitPrice)}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        if (item.sku != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            'SKU: ${item.sku}',
                            style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    _money(item.lineTotal),
                    style: const TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  const _PaymentSummaryCard({
    required this.order,
  });

  final OrderDetailsData order;

  static const Color _primary = Color(0xFF00509D);

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.payments_outlined,
            title: 'Payment Summary',
          ),

          const SizedBox(height: 10),

          _InfoRow(label: 'Subtotal', value: _money(order.subtotal)),
          _InfoRow(label: 'Shipping Fee', value: _money(order.shippingFee)),
          _InfoRow(label: 'Discount', value: _money(order.discount)),

          const Divider(height: 18),

          _InfoRow(
            label: 'Total',
            value: _money(order.total),
            isBold: true,
            valueColor: _primary,
          ),
          _InfoRow(
            label: 'Payment Status',
            value: order.paymentStatus.capitalizeFirst ?? order.paymentStatus,
            isBold: true,
            valueColor: _paymentColor(order.paymentStatus),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
  });

  final String note;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.sticky_note_2_outlined,
            title: 'Customer Note',
          ),
          const SizedBox(height: 8),
          Text(
            note,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.order,
  });

  final OrderDetailsData order;

  static const Color _primary = Color(0xFF00509D);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.offNamed(Routes.ORDER_HISTORY);
            },
            icon: const Icon(Icons.list_alt_outlined),
            label: const Text(
              'Back to My Orders',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 48,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              offAllToStoreHomeOrRoot();
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text(
              'Continue Shopping',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF151738),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
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
    final label = text.trim().isEmpty ? 'N/A' : text.capitalizeFirst ?? text;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.symmetric(vertical: 4.5),
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
                color: valueColor ?? const Color(0xFF151738),
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w800,
                fontSize: isBold ? 13 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDetailsSkeleton extends StatelessWidget {
  const _OrderDetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        return Container(
          height: index == 0 ? 170 : 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade400,
              size: 58,
            ),
            const SizedBox(height: 12),
            Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.grey.shade900,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Order details not found',
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TimelineStepData {
  const _TimelineStepData(this.label, this.icon);

  final String label;
  final IconData icon;
}

int _statusStep(String status) {
  final value = status.toLowerCase().trim();

  if (value == 'pending') return 0;
  if (value == 'confirmed') return 1;
  if (value == 'processing') return 2;
  if (value == 'shipped' || value == 'on_the_way') return 3;
  if (value == 'delivered' || value == 'completed') return 4;

  return 0;
}

Color _statusColor(String status) {
  final value = status.toLowerCase().trim();

  if (value == 'pending') return Colors.orange;
  if (value == 'confirmed') return Colors.blue;
  if (value == 'processing') return Colors.deepPurple;
  if (value == 'shipped' || value == 'on_the_way') return Colors.indigo;
  if (value == 'delivered' || value == 'completed') return const Color(0xFF16A34A);
  if (value == 'cancelled' || value == 'failed') return Colors.redAccent;

  return Colors.grey;
}

Color _paymentColor(String status) {
  final value = status.toLowerCase().trim();

  if (value == 'paid') return const Color(0xFF16A34A);
  if (value == 'unpaid') return Colors.redAccent;
  if (value == 'partial') return Colors.orange;

  return Colors.grey;
}

String _money(num value) {
  if (value % 1 == 0) {
    return '৳${value.toInt()}';
  }

  return '৳${value.toStringAsFixed(2)}';
}

String _date(DateTime? date) {
  if (date == null) return 'N/A';

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();

  return '$day-$month-$year';
}

String _initials(String name) {
  final clean = name.trim();

  if (clean.isEmpty) return 'D';

  final parts = clean.split(RegExp(r'\s+'));

  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  return clean.substring(0, 1).toUpperCase();
}
