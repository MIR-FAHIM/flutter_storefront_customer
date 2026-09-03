import 'package:ecom_user_flutter/app/models/chat_model.dart';
import 'package:ecom_user_flutter/app/modules/customer_chat/controllers/customer_chat_controller.dart';
import 'package:ecom_user_flutter/app/modules/customer_chat/views/widgets/customer_chat_widgets.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerConversationListView extends GetView<CustomerChatController> {
  const CustomerConversationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Shop Chat'),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoadingConversations.value &&
            controller.conversations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty &&
            controller.conversations.isEmpty) {
          return ChatErrorState(
            message: controller.error.value,
            onRetry: controller.refreshConversations,
          );
        }

        if (controller.conversations.isEmpty) {
          return const ChatEmptyState(
            title: 'No shop conversations yet',
            message: 'Messages with MyZoo stores will appear here.',
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: controller.refreshConversations,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.axis == Axis.vertical &&
                  notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 180) {
                controller.getConversations();
              }
              return false;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 110),
              itemCount: controller.conversations.length +
                  (controller.isLoadingConversations.value ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index >= controller.conversations.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _ConversationTile(
                  conversation: controller.conversations[index],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final id = conversation.id;
          if (id == null) return;
          Get.toNamed(
            Routes.SHOP_CHAT_THREAD,
            arguments: {
              'conversation_id': id,
              'conversation': conversation,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ChatAvatar(
                name: conversation.shopName,
                imageUrl: conversation.shopLogo,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _timeText(conversation.updatedAt ?? conversation.createdAt),
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (conversation.unreadCount > 0)
                    Container(
                      constraints: const BoxConstraints(minWidth: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        conversation.unreadCount > 99
                            ? '99+'
                            : conversation.unreadCount.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeText(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    if (now.difference(date).inDays == 0) {
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}
