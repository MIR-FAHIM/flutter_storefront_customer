import 'package:ecom_user_flutter/app/models/chat_model.dart';
import 'package:ecom_user_flutter/app/modules/customer_chat/repositories/customer_chat_repository.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/common/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerChatController extends GetxController {
  final CustomerChatRepository _repo = CustomerChatRepository();

  final conversations = <Conversation>[].obs;
  final messages = <ChatMessage>[].obs;
  final activeConversation = Rxn<Conversation>();
  final messageController = TextEditingController();
  final replyPreview = Rxn<ChatMessage>();

  final isLoadingConversations = false.obs;
  final isLoadingMessages = false.obs;
  final isSending = false.obs;
  final isOpeningConversation = false.obs;
  final error = ''.obs;
  final messageError = ''.obs;
  final currentConversationPage = 1.obs;
  final lastConversationPage = 1.obs;
  final hasMoreConversations = true.obs;
  final currentMessagePage = 1.obs;
  final lastMessagePage = 1.obs;
  final hasMoreMessages = true.obs;

  final _readMessageIds = <int>{};
  final _readConversationIds = <int>{};
  int _conversationRequestToken = 0;
  int _messageRequestToken = 0;
  int? _loadedConversationId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final conversationId = _readInt(args, const {
      'conversation_id',
      'conversationId',
      'id',
    });
    final shopId = _readInt(args, const {'shop_id', 'shopId'});

    if (conversationId != null) {
      openThread(conversationId: conversationId);
    } else if (shopId != null) {
      startConversation(shopId: shopId);
    } else {
      getConversations(reset: true);
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  bool get _isLoggedIn {
    return Get.find<AuthService>().currentUser.value.data != null;
  }

  Future<void> getConversations({bool reset = false}) async {
    if (!_guardLogin()) return;
    if (!reset && !hasMoreConversations.value) return;
    if (!reset && isLoadingConversations.value) return;

    final token = ++_conversationRequestToken;
    if (reset) {
      currentConversationPage.value = 1;
      lastConversationPage.value = 1;
      hasMoreConversations.value = true;
      conversations.clear();
    }

    isLoadingConversations.value = true;
    error.value = '';

    try {
      final response = await _repo.getConversations(
        page: currentConversationPage.value,
      );
      if (token != _conversationRequestToken) return;

      if (_isSuccess(response)) {
        final page = ChatPaginatedResponse<Conversation>.fromJson(
          Map<String, dynamic>.from(response),
          Conversation.fromJson,
        );
        if (reset) {
          conversations.assignAll(page.items);
        } else {
          conversations.addAll(page.items);
        }
        currentConversationPage.value =
            page.currentPage < page.lastPage ? page.currentPage + 1 : page.currentPage;
        lastConversationPage.value = page.lastPage;
        hasMoreConversations.value = page.currentPage < page.lastPage;
        return;
      }

      if (reset) conversations.clear();
      error.value = _messageForResponse(response);
      _redirectIfUnauthorized(response);
    } catch (e) {
      if (token == _conversationRequestToken) {
        if (reset) conversations.clear();
        error.value = _messageFromException(e);
      }
    } finally {
      if (token == _conversationRequestToken) {
        isLoadingConversations.value = false;
      }
    }
  }

  Future<void> refreshConversations() => getConversations(reset: true);

  Future<void> openThread({required int conversationId}) async {
    if (!_guardLogin()) return;
    _loadedConversationId = conversationId;
    activeConversation.value = Conversation(id: conversationId);
    await markConversationRead(conversationId);
    await getConversation(conversationId);
    await getMessages(conversationId: conversationId, reset: true);
  }

  Future<void> ensureThreadLoaded({
    int? conversationId,
    int? shopId,
    Conversation? conversation,
  }) async {
    if (conversation != null) {
      activeConversation.value = conversation;
    }

    final resolvedConversationId = conversationId ?? conversation?.id;
    if (resolvedConversationId != null) {
      if (_loadedConversationId == resolvedConversationId &&
          messages.isNotEmpty) {
        return;
      }
      await openThread(conversationId: resolvedConversationId);
      return;
    }

    if (shopId != null) {
      await startConversation(shopId: shopId, navigateToThread: false);
    }
  }

  Future<void> startConversation({
    required int shopId,
    bool navigateToThread = true,
  }) async {
    if (!_guardLogin()) return;
    if (isOpeningConversation.value) return;

    isOpeningConversation.value = true;
    error.value = '';

    try {
      final response = await _repo.openOrCreateConversation(shopId: shopId);
      if (_isSuccess(response)) {
        final conversation = _conversationFromResponse(response);
        final conversationId = conversation?.id;
        if (conversationId == null) {
          throw Exception('Conversation id missing from backend response');
        }
        activeConversation.value = conversation;
        _loadedConversationId = conversationId;
        await getMessages(conversationId: conversationId, reset: true);
        if (navigateToThread) {
          Get.toNamed(
            Routes.SHOP_CHAT_THREAD,
            arguments: {
              'conversation_id': conversationId,
              'conversation': conversation,
            },
          );
        }
        return;
      }

      final message = _messageForResponse(response);
      Get.showSnackbar(Ui.ErrorSnackBar(title: 'Chat'.tr, message: message));
      _redirectIfUnauthorized(response);
    } catch (e) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(title: 'Chat'.tr, message: _messageFromException(e)),
      );
    } finally {
      isOpeningConversation.value = false;
    }
  }

  Future<void> getConversation(int conversationId) async {
    try {
      final response = await _repo.getConversation(conversationId: conversationId);
      if (_isSuccess(response)) {
        final conversation = _conversationFromResponse(response);
        if (conversation != null) activeConversation.value = conversation;
      }
    } catch (_) {}
  }

  Future<void> getMessages({
    required int conversationId,
    bool reset = false,
  }) async {
    if (!_guardLogin()) return;
    if (!reset && !hasMoreMessages.value) return;
    if (!reset && isLoadingMessages.value) return;

    final token = ++_messageRequestToken;
    if (reset) {
      currentMessagePage.value = 1;
      lastMessagePage.value = 1;
      hasMoreMessages.value = true;
      messages.clear();
    }

    isLoadingMessages.value = true;
    messageError.value = '';

    try {
      final response = await _repo.getMessages(
        conversationId: conversationId,
        page: currentMessagePage.value,
      );
      if (token != _messageRequestToken) return;

      if (_isSuccess(response)) {
        final page = ChatPaginatedResponse<ChatMessage>.fromJson(
          Map<String, dynamic>.from(response),
          ChatMessage.fromJson,
        );
        if (reset) {
          messages.assignAll(page.items.reversed.toList());
        } else {
          messages.insertAll(0, page.items.reversed);
        }
        currentMessagePage.value =
            page.currentPage < page.lastPage ? page.currentPage + 1 : page.currentPage;
        lastMessagePage.value = page.lastPage;
        hasMoreMessages.value = page.currentPage < page.lastPage;
        _markVisibleIncomingMessagesRead();
        return;
      }

      messageError.value = _messageForResponse(response);
      _redirectIfUnauthorized(response);
    } catch (e) {
      if (token == _messageRequestToken) {
        messageError.value = _messageFromException(e);
      }
    } finally {
      if (token == _messageRequestToken) {
        isLoadingMessages.value = false;
      }
    }
  }

  Future<void> sendTextMessage() async {
    final conversationId = activeConversation.value?.id;
    final text = messageController.text.trim();
    if (conversationId == null || text.isEmpty || isSending.value) return;

    final replyId = replyPreview.value?.id;
    final pending = ChatMessage.pending(
      conversationId: conversationId,
      message: text,
      replyToMessageId: replyId,
    );

    messages.add(pending);
    messageController.clear();
    replyPreview.value = null;
    isSending.value = true;

    try {
      final response = await _repo.sendMessage(
        conversationId: conversationId,
        message: text,
        replyToMessageId: replyId,
      );
      if (_isSuccess(response)) {
        final sent = _messageFromResponse(response);
        final index = messages.indexOf(pending);
        if (index >= 0 && sent != null) {
          messages[index] = sent;
        } else {
          pending.isDelivered = true;
          messages.refresh();
        }
        await getConversations(reset: true);
        return;
      }

      pending.isFailed = true;
      messages.refresh();
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          title: 'Chat'.tr,
          message: _messageForResponse(response),
        ),
      );
      _redirectIfUnauthorized(response);
    } catch (e) {
      pending.isFailed = true;
      messages.refresh();
      Get.showSnackbar(
        Ui.ErrorSnackBar(title: 'Chat'.tr, message: _messageFromException(e)),
      );
    } finally {
      isSending.value = false;
    }
  }

  Future<void> markConversationRead(int conversationId) async {
    if (_readConversationIds.contains(conversationId)) return;
    _readConversationIds.add(conversationId);
    try {
      final response = await _repo.markConversationRead(conversationId);
      if (_isSuccess(response)) {
        final index = conversations.indexWhere((item) => item.id == conversationId);
        if (index >= 0) {
          conversations[index].unreadCount = 0;
          conversations.refresh();
        }
      }
    } catch (_) {}
  }

  Future<void> markMessageRead(ChatMessage message) async {
    final id = message.id;
    if (id == null || message.isFromCustomer || _readMessageIds.contains(id)) {
      return;
    }

    _readMessageIds.add(id);
    try {
      final response = await _repo.markMessageRead(id);
      if (_isSuccess(response)) {
        message.isRead = true;
        message.isSeen = true;
        messages.refresh();
      }
    } catch (_) {}
  }

  void setReply(ChatMessage message) {
    replyPreview.value = message;
  }

  void clearReply() {
    replyPreview.value = null;
  }

  void _markVisibleIncomingMessagesRead() {
    for (final message in messages) {
      markMessageRead(message);
    }
  }

  bool _guardLogin() {
    if (_isLoggedIn) return true;
    Get.toNamed(Routes.LOGIN);
    return false;
  }

  bool _isSuccess(dynamic response) {
    if (response is! Map) return false;
    return response['status']?.toString().toLowerCase() == 'success' ||
        response['success'] == true;
  }

  Conversation? _conversationFromResponse(dynamic response) {
    if (response is! Map) return null;
    final data = response['data'];
    if (data is Map && data['conversation'] is Map) {
      return Conversation.fromJson(Map<String, dynamic>.from(data['conversation']));
    }
    if (data is Map) return Conversation.fromJson(Map<String, dynamic>.from(data));
    return null;
  }

  ChatMessage? _messageFromResponse(dynamic response) {
    if (response is! Map) return null;
    final data = response['data'];
    if (data is Map && data['message'] is Map) {
      return ChatMessage.fromJson(Map<String, dynamic>.from(data['message']));
    }
    if (data is Map) return ChatMessage.fromJson(Map<String, dynamic>.from(data));
    return null;
  }

  String _messageForResponse(dynamic response) {
    if (response is Map) {
      final status = response['status']?.toString();
      final code = response['status_code']?.toString();
      final message = response['message']?.toString();
      if (status == '403' || code == '403') return 'You do not have permission.';
      if (status == '404' || code == '404') return 'Conversation not found.';
      if (message != null && message.trim().isNotEmpty) return message;
    }
    return 'Something went wrong. Please try again.';
  }

  String _messageFromException(Object error) {
    final text = error.toString();
    if (text.contains('StatusCode: 404')) return 'Conversation not found.';
    if (text.contains('StatusCode: 500')) {
      return 'Something went wrong. Please try again.';
    }
    return text.replaceFirst('Exception: ', '');
  }

  void _redirectIfUnauthorized(dynamic response) {
    if (response is! Map) return;
    final status = response['status']?.toString();
    final code = response['status_code']?.toString();
    final message = response['message']?.toString().toLowerCase() ?? '';
    if (status == '401' ||
        code == '401' ||
        message.contains('unauthenticated') ||
        message.contains('invalid or expired api token')) {
      Get.find<AuthService>().removeCurrentUser();
      Get.offNamed(Routes.LOGIN);
    }
  }

  int? _readInt(dynamic source, Set<String> keys) {
    if (source is int) return source;
    if (source is Map) {
      for (final key in keys) {
        final value = source[key];
        final parsed = _asInt(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ??
        double.tryParse(value.toString())?.toInt();
  }
}
