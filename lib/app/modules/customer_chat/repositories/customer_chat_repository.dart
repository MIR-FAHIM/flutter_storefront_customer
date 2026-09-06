import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:get/get.dart';

class CustomerChatRepository {
  final APIManager _manager = APIManager();

  Map<String, String> get header => {
        'Authorization':
            'Bearer ${Get.find<AuthService>().currentUser.value.data!.token}',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };

  Future<dynamic> getConversations({
    int page = 1,
    int perPage = 20,
  }) {
    final uri = Uri.parse(ApiClient.chatConversations).replace(
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    return _manager.getWithHeader(uri.toString(), header);
  }

  Future<dynamic> openOrCreateConversation({required int shopId}) {
    return _manager.postAPICallWithHeader(
      ApiClient.chatConversations,
      {'shop_id': shopId.toString()},
      header,
    );
  }

  Future<dynamic> getConversation({required int conversationId}) {
    return _manager.getWithHeader(
      '${ApiClient.chatConversations}/$conversationId',
      header,
    );
  }

  Future<dynamic> getMessages({
    required int conversationId,
    int page = 1,
    int perPage = 30,
  }) {
    final uri = Uri.parse(
      '${ApiClient.chatConversations}/$conversationId/messages',
    ).replace(
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    return _manager.getWithHeader(uri.toString(), header);
  }

  Future<dynamic> sendMessage({
    required int conversationId,
    required String message,
    String messageType = 'text',
    int? productId,
    int? orderId,
    int? replyToMessageId,
  }) {
    return _manager.postAPICallWithHeader(
      '${ApiClient.chatConversations}/$conversationId/messages',
      {
        'message_type': messageType,
        'message': message,
        if (productId != null) 'product_id': productId.toString(),
        if (orderId != null) 'order_id': orderId.toString(),
        if (replyToMessageId != null)
          'reply_to_message_id': replyToMessageId.toString(),
      },
      header,
    );
  }

  Future<dynamic> markMessageRead(int messageId) {
    return _manager.postAPICallHeader(
      '${ApiClient.chatMessages}/$messageId/read',
      header,
    );
  }

  Future<dynamic> markConversationRead(int conversationId) {
    return _manager.postAPICallHeader(
      '${ApiClient.chatConversationsRead}/$conversationId/read',
      header,
    );
  }
}
