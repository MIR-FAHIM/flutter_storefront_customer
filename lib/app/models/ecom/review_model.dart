class Review {
  final int? id;
  final int? userId;
  final int? productId;
  final int? shopId;
  final String? comment;
  final int? starCount;
  final bool? status;
  final int? priority;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserResponse? user;
  final ProductResponse? product;
  final ShopResponse? shop;

  const Review({
    this.id,
    this.userId,
    this.productId,
    this.shopId,
    this.comment,
    this.starCount,
    this.status,
    this.priority,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.product,
    this.shop,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: _asInt(json['id']),
        userId: _asInt(json['user_id']),
        productId: _asInt(json['product_id']),
        shopId: _asInt(json['shop_id']),
        comment: json['comment']?.toString(),
        starCount: _asInt(json['star_count']),
        status: json['status'] is bool ? json['status'] as bool : null,
        priority: _asInt(json['priority']),
        type: json['type']?.toString(),
        createdAt: _asDate(json['created_at']),
        updatedAt: _asDate(json['updated_at']),
        user: _asMap(json['user']) == null
            ? null
            : UserResponse.fromJson(_asMap(json['user'])!),
        product: _asMap(json['product']) == null
            ? null
            : ProductResponse.fromJson(_asMap(json['product'])!),
        shop: _asMap(json['shop']) == null
            ? null
            : ShopResponse.fromJson(_asMap(json['shop'])!),
      );
}

class ReviewListResponse {
  final String? status;
  final String? message;
  final int count;
  final List<Review> items;

  const ReviewListResponse({
    this.status,
    this.message,
    this.count = 0,
    this.items = const [],
  });

  factory ReviewListResponse.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']) ?? const <String, dynamic>{};
    final rawItems = data['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => Review.fromJson(Map<String, dynamic>.from(item)))
            .toList()
        : <Review>[];

    return ReviewListResponse(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      count: _asInt(data['count']) ?? items.length,
      items: items,
    );
  }
}

class UserResponse {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;

  const UserResponse({this.id, this.name, this.email, this.phone});

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: _asInt(json['id']),
        name: json['name']?.toString(),
        email: json['email']?.toString(),
        phone: json['phone']?.toString(),
      );
}

class ProductResponse {
  final int? id;
  final String? name;
  final String? slug;

  const ProductResponse({this.id, this.name, this.slug});

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        id: _asInt(json['id']),
        name: json['name']?.toString(),
        slug: json['slug']?.toString(),
      );
}

class ShopResponse {
  final int? id;
  final String? name;
  final String? shopName;
  final String? slug;

  const ShopResponse({this.id, this.name, this.shopName, this.slug});

  factory ShopResponse.fromJson(Map<String, dynamic> json) => ShopResponse(
        id: _asInt(json['id']),
        name: json['name']?.toString(),
        shopName: json['shop_name']?.toString(),
        slug: json['slug']?.toString(),
      );
}

Map<String, dynamic>? _asMap(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;

int? _asInt(dynamic value) => value is int ? value : int.tryParse('$value');

DateTime? _asDate(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
