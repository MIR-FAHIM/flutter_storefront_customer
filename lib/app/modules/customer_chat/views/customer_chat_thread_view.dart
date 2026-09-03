import 'package:ecom_user_flutter/app/models/chat_model.dart';
import 'package:ecom_user_flutter/app/modules/customer_chat/controllers/customer_chat_controller.dart';
import 'package:ecom_user_flutter/app/modules/customer_chat/views/widgets/customer_chat_widgets.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerChatThreadView extends StatefulWidget {
  const CustomerChatThreadView({super.key});

  @override
  State<CustomerChatThreadView> createState() => _CustomerChatThreadViewState();
}

class _CustomerChatThreadViewState extends State<CustomerChatThreadView> {
  final CustomerChatController controller = Get.find<CustomerChatController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      final conversation = args is Map && args['conversation'] is Conversation
          ? args['conversation'] as Conversation
          : null;
      controller.ensureThreadLoaded(
        conversationId: _readInt(args, const {
          'conversation_id',
          'conversationId',
          'id',
        }),
        shopId: _readInt(args, const {'shop_id', 'shopId'}),
        conversation: conversation,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        titleSpacing: 0,
        title: Obx(() {
          final conversation = controller.activeConversation.value;
          final name = conversation?.shopName ?? 'Shop Chat';
          return Row(
            children: [
              ChatAvatar(
                name: name,
                imageUrl: conversation?.shopLogo,
                radius: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'MyZoo store',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final conversationId = controller.activeConversation.value?.id;
              if (controller.isLoadingMessages.value &&
                  controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.messageError.value.isNotEmpty &&
                  controller.messages.isEmpty) {
                return ChatErrorState(
                  message: controller.messageError.value,
                  onRetry: conversationId == null
                      ? () {}
                      : () => controller.getMessages(
                            conversationId: conversationId,
                            reset: true,
                          ),
                );
              }

              if (controller.messages.isEmpty) {
                return const ChatEmptyState(
                  title: 'Start the conversation',
                  message: 'Send a message to this MyZoo store.',
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (conversationId != null &&
                      notification.metrics.axis == Axis.vertical &&
                      notification.metrics.pixels <= 120) {
                    controller.getMessages(conversationId: conversationId);
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return ChatMessageBubble(
                      message: message,
                      onReply: () => controller.setReply(message),
                    );
                  },
                ),
              );
            }),
          ),
          _Composer(),
        ],
      ),
    );
  }

  int? _readInt(dynamic source, Set<String> keys) {
    if (source is int) return source;
    if (source is Map) {
      for (final key in keys) {
        final value = source[key];
        if (value is int) return value;
        if (value is double) return value.toInt();
        final parsed = int.tryParse(value?.toString() ?? '');
        if (parsed != null) return parsed;
      }
    }
    return null;
  }
}

class _Composer extends GetView<CustomerChatController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final reply = controller.replyPreview.value;
              if (reply == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ReplyPreviewBox(
                        message: reply.message,
                      ),
                    ),
                    IconButton(
                      onPressed: controller.clearReply,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: const Color(0xFFF4F6F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => InkWell(
                    borderRadius: BorderRadius.circular(99),
                    onTap: controller.isSending.value
                        ? null
                        : controller.sendTextMessage,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: controller.isSending.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
