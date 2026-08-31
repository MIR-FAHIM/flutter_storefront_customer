import 'dart:convert';

PreferredStoreResponse preferredStoreResponseFromJson(String source) {
  return PreferredStoreResponse.fromJson(
    json.decode(source) as Map<String, dynamic>,
  );
}

class PreferredStoreResponse {
  final String status;
  final String message;
  final PreferredStorePage data;

  const PreferredStoreResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PreferredStoreResponse.fromJson(Map<String, dynamic> json) {
    return PreferredStoreResponse(
      status: _string(json['status']),
      message: _string(json['message']),
      data: PreferredStorePage.fromJson(_map(json['data']) ?? const {}),
    );
  }
}

class PreferredStorePage {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final List<PreferredStoreItem> items;

  const PreferredStorePage({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.items,
  });

  factory PreferredStorePage.fromJson(Map<String, dynamic> json) {
    return PreferredStorePage(
      currentPage: _int(json['current_page'], 1),
      lastPage: _int(json['last_page'], 1),
      perPage: _int(json['per_page'], 20),
      total: _int(json['total'], 0),
      items: _list(json['data'])
          .map(_map)
          .whereType<Map<String, dynamic>>()
          .map(PreferredStoreItem.fromJson)
          .toList(),
    );
  }
}

class PreferredStoreItem {
  final int? id;
  final int? customerUserId;
  final int? sellerId;
  String status;
  final DateTime? createdAt;
  final PreferredSeller? seller;

  PreferredStoreItem({
    this.id,
    this.customerUserId,
    this.sellerId,
    required this.status,
    this.createdAt,
    this.seller,
  });

  factory PreferredStoreItem.fromJson(Map<String, dynamic> json) {
    final seller = _map(json['seller']);
    return PreferredStoreItem(
      id: _nullableInt(json['id']),
      customerUserId: _nullableInt(json['customer_user_id']),
      sellerId: _nullableInt(json['seller_id']),
      status: _string(json['status'], fallback: 'inactive'),
      createdAt: _date(json['created_at']),
      seller: seller == null ? null : PreferredSeller.fromJson(seller),
    );
  }

  PreferredStoreShop? get shop => seller?.shop ?? seller?.store;
  int? get resolvedSellerId => sellerId ?? seller?.id;

  String get displayName {
    final shop = this.shop;
    return _firstText([shop?.shopName, shop?.name, seller?.name]) ??
        'Preferred Store';
  }

  String get slug => shop?.slug ?? '';
  String get logoUrl => shop?.logoUrl ?? seller?.avatar ?? '';
  String get bannerUrl => shop?.bannerUrl ?? '';
  String get phoneText => shop?.phone ?? '-';
  String get addressText => shop?.address ?? '-';
  String get districtText => shop?.district ?? '-';
}

class PreferredSeller {
  final int? id;
  final String? name;
  final String? avatar;
  final String? email;
  final PreferredStoreShop? shop;
  final PreferredStoreShop? store;

  const PreferredSeller({
    this.id,
    this.name,
    this.avatar,
    this.email,
    this.shop,
    this.store,
  });

  factory PreferredSeller.fromJson(Map<String, dynamic> json) {
    return PreferredSeller(
      id: _nullableInt(json['id']),
      name: _nullableString(json['name']),
      avatar: _mediaUrl(json['avatar']),
      email: _nullableString(json['email']),
      shop: _map(json['shop']) == null
          ? null
          : PreferredStoreShop.fromJson(_map(json['shop'])!),
      store: _map(json['store']) == null
          ? null
          : PreferredStoreShop.fromJson(_map(json['store'])!),
    );
  }
}

class PreferredStoreShop {
  final int? id;
  final String? name;
  final String? shopName;
  final String? slug;
  final String? logoUrl;
  final String? bannerUrl;
  final String? phone;
  final String? address;
  final String? district;

  const PreferredStoreShop({
    this.id,
    this.name,
    this.shopName,
    this.slug,
    this.logoUrl,
    this.bannerUrl,
    this.phone,
    this.address,
    this.district,
  });

  factory PreferredStoreShop.fromJson(Map<String, dynamic> json) {
    return PreferredStoreShop(
      id: _nullableInt(json['id']),
      name: _nullableString(json['name']),
      shopName: _nullableString(json['shop_name']),
      slug: _nullableString(json['slug']),
      logoUrl: _mediaUrl(json['logo']),
      bannerUrl: _mediaUrl(json['banner']),
      phone: _nullableString(json['phone']),
      address: _nullableString(json['address']),
      district: _nullableString(json['district']),
    );
  }
}

Map<String, dynamic>? _map(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

List<dynamic> _list(dynamic value) => value is List ? value : const [];

String _string(dynamic value, {String fallback = ''}) =>
    _nullableString(value) ?? fallback;

String? _nullableString(dynamic value) {
  if (value == null) return null;
  final result = value.toString().trim();
  return result.isEmpty || result.toLowerCase() == 'null' ? null : result;
}

String? _mediaUrl(dynamic value) {
  if (value is String) return _nullableString(value);
  return _nullableString(_map(value)?['url']);
}

String? _firstText(Iterable<String?> values) {
  for (final value in values) {
    final text = _nullableString(value);
    if (text != null) return text;
  }
  return null;
}

int _int(dynamic value, int fallback) => _nullableInt(value) ?? fallback;

int? _nullableInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  return value == null ? null : int.tryParse(value.toString());
}

DateTime? _date(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
