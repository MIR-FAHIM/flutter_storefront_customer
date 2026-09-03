import 'dart:convert';

ChatPaginatedResponse<Conversation> chatConversationResponseFromJson(
  String str,
) =>
    ChatPaginatedResponse.fromJson(
      json.decode(str) as Map<String, dynamic>,
      Conversation.fromJson,
    );

ChatPaginatedResponse<ChatMessage> chatMessageResponseFromJson(String str) =>
    ChatPaginatedResponse.fromJson(
      json.decode(str) as Map<String, dynamic>,
      ChatMessage.fromJson,
    );

enum ChatMessageType {
  text,
  product,
  order,
  orderStatus,
  system,
  image,
  voice,
  file,
  unknown,
}

enum ChatSenderType {
  customer,
  shop,
  system,
  unknown,
}

class ChatPaginatedResponse<T> {
  final String status;
  final String message;
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const ChatPaginatedResponse({
    required this.status,
    required this.message,
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ChatPaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) parser,
  ) {
    final data = json['data'];
    final rawItems = data is Map ? data['data'] : data;
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => parser(Map<String, dynamic>.from(item)))
            .toList()
        : <T>[];

    return ChatPaginatedResponse<T>(
      status: _string(json['status']),
      message: _string(json['message']),
      items: items,
      currentPage: _int(data is Map ? data['current_page'] : 1) ?? 1,
      lastPage: _int(data is Map ? data['last_page'] : 1) ?? 1,
      perPage:
          _int(data is Map ? data['per_page'] : items.length) ?? items.length,
      total: _int(data is Map ? data['total'] : items.length) ?? items.length,
    );
  }
}

class Conversation {
  final int? id;
  final int? shopId;
  final ConversationShop? shop;
  final ConversationCustomer? customer;
  final ChatMessage? lastMessage;
  int unreadCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Conversation({
    this.id,
    this.shopId,
    this.shop,
    this.customer,
    this.lastMessage,
    this.unreadCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final shopMap = _asMap(json['shop']) ??
        _asMap(_asMap(json['seller'])?['shop']) ??
        _asMap(json['store']);
    return Conversation(
      id: _int(json['id']) ??
          _int(json['conversation_id']) ??
          _int(json['conversation_room_id']),
      shopId: _int(json['shop_id']) ?? _int(shopMap?['id']),
      shop: shopMap == null ? null : ConversationShop.fromJson(shopMap),
      customer: _asMap(json['customer']) == null
          ? null
          : ConversationCustomer.fromJson(_asMap(json['customer'])!),
      lastMessage: _asMap(json['last_message']) == null
          ? null
          : ChatMessage.fromJson(_asMap(json['last_message'])!),
      unreadCount:
          _int(json['unread_count'] ?? json['unread_messages_count']) ?? 0,
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
    );
  }

  String get shopName => _firstNotEmpty([shop?.shopName, shop?.name, 'Shop']);

  String get shopLogo => _firstNotEmpty([shop?.logoUrl, shop?.avatar]);

  String get preview {
    final message = lastMessage;
    if (message == null) return 'No messages yet';
    if (message.message.trim().isNotEmpty) return message.message;
    switch (message.type) {
      case ChatMessageType.product:
        return 'Product message';
      case ChatMessageType.order:
      case ChatMessageType.orderStatus:
        return 'Order update';
      case ChatMessageType.image:
        return 'Image';
      case ChatMessageType.voice:
        return 'Voice message';
      case ChatMessageType.file:
        return 'File';
      case ChatMessageType.system:
        return 'System message';
      case ChatMessageType.text:
      case ChatMessageType.unknown:
        return 'Message';
    }
  }
}

class ConversationShop {
  final int? id;
  final int? userId;
  final String? name;
  final String? shopName;
  final String? slug;
  final String? logoUrl;
  final String? avatar;
  final String? status;

  const ConversationShop({
    this.id,
    this.userId,
    this.name,
    this.shopName,
    this.slug,
    this.logoUrl,
    this.avatar,
    this.status,
  });

  factory ConversationShop.fromJson(Map<String, dynamic> json) {
    return ConversationShop(
      id: _int(json['id']),
      userId: _int(json['user_id']),
      name: _nullableString(json['name']),
      shopName: _nullableString(json['shop_name']),
      slug: _nullableString(json['slug']),
      logoUrl: _mediaUrl(json['logo']),
      avatar:
          _nullableString(json['avatar']) ?? _nullableString(json['avatar_original']),
      status: _nullableString(json['status']),
    );
  }
}

class ConversationCustomer {
  final int? id;
  final String? name;
  final String? avatar;

  const ConversationCustomer({
    this.id,
    this.name,
    this.avatar,
  });

  factory ConversationCustomer.fromJson(Map<String, dynamic> json) {
    return ConversationCustomer(
      id: _int(json['id']),
      name: _nullableString(json['name']),
      avatar:
          _nullableString(json['avatar']) ?? _nullableString(json['avatar_original']),
    );
  }
}

class ChatMessage {
  int? id;
  int? conversationId;
  int? senderId;
  ChatSenderType senderType;
  String message;
  ChatMessageType type;
  bool isRead;
  bool isDelivered;
  bool isSeen;
  bool isFailed;
  DateTime? createdAt;
  ChatSender? sender;
  ChatProduct? product;
  ChatOrder? order;
  ReplyPreview? replyTo;

  ChatMessage({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderType = ChatSenderType.unknown,
    this.message = '',
    this.type = ChatMessageType.text,
    this.isRead = false,
    this.isDelivered = false,
    this.isSeen = false,
    this.isFailed = false,
    this.createdAt,
    this.sender,
    this.product,
    this.order,
    this.replyTo,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final sender = _asMap(json['sender']);
    return ChatMessage(
      id: _int(json['id']),
      conversationId:
          _int(json['conversation_id']) ?? _int(json['conversation_room_id']),
      senderId: _int(json['sender_id']),
      senderType: _senderType(
        json['sender_type'] ??
            json['from_type'] ??
            sender?['user_type'] ??
            sender?['type'],
      ),
      message: _string(json['message'] ?? json['body'] ?? json['text']),
      type: _messageType(json['message_type'] ?? json['type']),
      isRead: _bool(json['is_read'] ?? json['read']),
      isDelivered: _bool(json['is_delivered'] ?? json['delivered']),
      isSeen: _bool(json['is_seen'] ?? json['seen']),
      createdAt: _date(json['created_at']),
      sender: sender == null ? null : ChatSender.fromJson(sender),
      product: _asMap(json['product']) == null
          ? null
          : ChatProduct.fromJson(_asMap(json['product'])!),
      order: _asMap(json['order']) == null
          ? null
          : ChatOrder.fromJson(_asMap(json['order'])!),
      replyTo: _asMap(json['reply_to']) == null
          ? null
          : ReplyPreview.fromJson(_asMap(json['reply_to'])!),
    );
  }

  factory ChatMessage.pending({
    required int conversationId,
    required String message,
    int? replyToMessageId,
  }) {
    return ChatMessage(
      conversationId: conversationId,
      senderType: ChatSenderType.customer,
      message: message,
      type: ChatMessageType.text,
      createdAt: DateTime.now(),
      replyTo: replyToMessageId == null
          ? null
          : ReplyPreview(id: replyToMessageId, message: ''),
    );
  }

  bool get isFromCustomer => senderType == ChatSenderType.customer;

  String get outgoingStatus {
    if (isFailed) return 'Failed';
    if (isRead || isSeen) return 'Read';
    if (isDelivered) return 'Delivered';
    return 'Sent';
  }
}

class ChatSender {
  final int? id;
  final String? name;
  final String? avatar;
  final ChatSenderType type;

  const ChatSender({
    this.id,
    this.name,
    this.avatar,
    this.type = ChatSenderType.unknown,
  });

  factory ChatSender.fromJson(Map<String, dynamic> json) {
    return ChatSender(
      id: _int(json['id']),
      name: _nullableString(json['name']),
      avatar: _nullableString(json['avatar']) ??
          _nullableString(json['avatar_original']) ??
          _mediaUrl(json['logo']),
      type: _senderType(json['user_type'] ?? json['type']),
    );
  }
}

class ChatProduct {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? price;

  const ChatProduct({
    this.id,
    this.name,
    this.imageUrl,
    this.price,
  });

  factory ChatProduct.fromJson(Map<String, dynamic> json) {
    return ChatProduct(
      id: _int(json['id'] ?? json['product_id']),
      name: _nullableString(json['name'] ?? json['product_name']),
      imageUrl: _mediaUrl(json['image'] ?? json['thumbnail'] ?? json['photo']),
      price: _nullableString(json['price'] ?? json['main_price']),
    );
  }
}

class ChatOrder {
  final int? id;
  final String? orderNumber;
  final String? status;
  final String? total;

  const ChatOrder({
    this.id,
    this.orderNumber,
    this.status,
    this.total,
  });

  factory ChatOrder.fromJson(Map<String, dynamic> json) {
    return ChatOrder(
      id: _int(json['id'] ?? json['order_id']),
      orderNumber: _nullableString(json['order_number'] ?? json['code']),
      status: _nullableString(json['status'] ?? json['delivery_status']),
      total: _nullableString(json['total'] ?? json['grand_total']),
    );
  }
}

class ReplyPreview {
  final int? id;
  final String message;

  const ReplyPreview({
    this.id,
    required this.message,
  });

  factory ReplyPreview.fromJson(Map<String, dynamic> json) {
    return ReplyPreview(
      id: _int(json['id']),
      message: _string(json['message']),
    );
  }
}

Map<String, dynamic>? _asMap(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : null;
}

String _firstNotEmpty(List<String?> values) {
  for (final value in values) {
    final clean = value?.trim();
    if (clean != null && clean.isNotEmpty) return clean;
  }
  return '';
}

String _string(dynamic value) => _nullableString(value) ?? '';

String? _nullableString(dynamic value) {
  final text = value?.toString().trim();
  return text == null || text.isEmpty || text.toLowerCase() == 'null'
      ? null
      : text;
}

int? _int(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.toInt();
}

bool _bool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value == 1;
  final text = value.toString().trim().toLowerCase();
  return text == 'true' || text == '1' || text == 'yes';
}

DateTime? _date(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

String? _mediaUrl(dynamic value) {
  if (value is Map) {
    final map = Map<String, dynamic>.from(value);
    return _nullableString(map['url']) ??
        _nullableString(map['resolved_url']) ??
        _nullableString(map['file_name']);
  }
  return _nullableString(value);
}

ChatMessageType _messageType(dynamic value) {
  switch (_string(value).toLowerCase()) {
    case 'text':
      return ChatMessageType.text;
    case 'product':
      return ChatMessageType.product;
    case 'order':
      return ChatMessageType.order;
    case 'order_status':
    case 'orderstatus':
      return ChatMessageType.orderStatus;
    case 'system':
      return ChatMessageType.system;
    case 'image':
      return ChatMessageType.image;
    case 'voice':
      return ChatMessageType.voice;
    case 'file':
      return ChatMessageType.file;
    default:
      return ChatMessageType.unknown;
  }
}

ChatSenderType _senderType(dynamic value) {
  final text = _string(value).toLowerCase();
  if (text.contains('customer')) return ChatSenderType.customer;
  if (text.contains('shop') ||
      text.contains('seller') ||
      text.contains('store')) {
    return ChatSenderType.shop;
  }
  if (text.contains('system')) return ChatSenderType.system;
  return ChatSenderType.unknown;
}
