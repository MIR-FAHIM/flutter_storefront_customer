import 'package:ecom_user_flutter/app/models/chat_model.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 22,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cleanUrl = imageUrl?.trim() ?? '';
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryColor.withOpacity(0.12),
      backgroundImage: cleanUrl.isEmpty ? null : NetworkImage(cleanUrl),
      child: cleanUrl.isEmpty
          ? Text(
              name.trim().isEmpty ? 'S' : name.trim()[0].toUpperCase(),
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w900,
              ),
            )
          : null,
    );
  }
}

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 58,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatErrorState extends StatelessWidget {
  const ChatErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

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
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onReply,
  });

  final ChatMessage message;
  final VoidCallback? onReply;

  @override
  Widget build(BuildContext context) {
    if (message.type == ChatMessageType.system) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.message,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    final outgoing = message.isFromCustomer;
    return Align(
      alignment: outgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onReply,
        child: Container(
          constraints: BoxConstraints(maxWidth: Get.width * 0.78),
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.fromLTRB(12, 9, 12, 7),
          decoration: BoxDecoration(
            color: outgoing ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(outgoing ? 14 : 3),
              bottomRight: Radius.circular(outgoing ? 3 : 14),
            ),
            border: outgoing ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment:
                outgoing ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.replyTo != null)
                ReplyPreviewBox(
                  message: message.replyTo!.message,
                  outgoing: outgoing,
                ),
              if (message.type == ChatMessageType.product &&
                  message.product != null)
                ProductMessageCard(product: message.product!)
              else if ((message.type == ChatMessageType.order ||
                      message.type == ChatMessageType.orderStatus) &&
                  message.order != null)
                OrderMessageCard(order: message.order!)
              else
                Text(
                  message.message.isEmpty ? 'Message' : message.message,
                  style: TextStyle(
                    color: outgoing ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              if (outgoing) ...[
                const SizedBox(height: 4),
                Text(
                  message.outgoingStatus,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.74),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyPreviewBox extends StatelessWidget {
  const ReplyPreviewBox({
    super.key,
    required this.message,
    this.outgoing = false,
  });

  final String message;
  final bool outgoing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: outgoing ? Colors.white.withOpacity(0.16) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: outgoing ? Colors.white70 : AppColors.primaryColor,
            width: 3,
          ),
        ),
      ),
      child: Text(
        message.isEmpty ? 'Reply' : message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: outgoing ? Colors.white : Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ProductMessageCard extends StatelessWidget {
  const ProductMessageCard({super.key, required this.product});

  final ChatProduct product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: product.id == null
          ? null
          : () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product.id),
      child: _RichCardShell(
        icon: Icons.inventory_2_outlined,
        imageUrl: product.imageUrl,
        title: product.name ?? 'Product',
        subtitle: product.price ?? '',
      ),
    );
  }
}

class OrderMessageCard extends StatelessWidget {
  const OrderMessageCard({super.key, required this.order});

  final ChatOrder order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: order.id == null
          ? null
          : () => Get.toNamed(Routes.ORDER_DETAIL, arguments: order.id),
      child: _RichCardShell(
        icon: Icons.receipt_long_outlined,
        title: order.orderNumber ?? 'Order #${order.id ?? ''}',
        subtitle: [order.status, order.total]
            .where((item) => item != null && item!.trim().isNotEmpty)
            .join(' - '),
      ),
    );
  }
}

class _RichCardShell extends StatelessWidget {
  const _RichCardShell({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.imageUrl,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final cleanUrl = imageUrl?.trim() ?? '';
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: cleanUrl.isEmpty
                ? Icon(icon, color: AppColors.primaryColor)
                : Image.network(cleanUrl, fit: BoxFit.cover),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                if (subtitle.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
