class ShopProfileResponse {
  final String status;
  final String message;
  final ShopProfile? data;

  const ShopProfileResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ShopProfileResponse.fromJson(Map<String, dynamic> json) {
    return ShopProfileResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map
          ? ShopProfile.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }
}

class ShopProfile {
  final int? id;
  final int? userId;
  final String? name;
  final String? shopName;
  final String? slug;
  final String? code;
  final String? logoUrl;
  final String? bannerUrl;
  final String? phone;
  final String? address;
  final String? district;
  final String? status;
  final ShopProfileUser? user;

  const ShopProfile({
    this.id,
    this.userId,
    this.name,
    this.shopName,
    this.slug,
    this.code,
    this.logoUrl,
    this.bannerUrl,
    this.phone,
    this.address,
    this.district,
    this.status,
    this.user,
  });

  factory ShopProfile.fromJson(Map<String, dynamic> json) {
    return ShopProfile(
      id: _int(json['id']),
      userId: _int(json['user_id']),
      name: _string(json['name']),
      shopName: _string(json['shop_name']),
      slug: _string(json['slug']),
      code: _string(json['code']),
      logoUrl: _mediaUrl(json['logo']),
      bannerUrl: _mediaUrl(json['banner']),
      phone: _string(json['phone']),
      address: _string(json['address']),
      district: _string(json['district']),
      status: _string(json['status']),
      user: json['user'] is Map
          ? ShopProfileUser.fromJson(Map<String, dynamic>.from(json['user']))
          : null,
    );
  }

  String get displayName => _firstNotEmpty([shopName, name, user?.name, 'Store']);
  String get phoneText => _firstNotEmpty([phone, '-']);
  String get addressText => _firstNotEmpty([address, '-']);
  String get districtText => _firstNotEmpty([district, '-']);
  String get sellerName => _firstNotEmpty([user?.name, '-']);
}

class ShopProfileUser {
  final int? id;
  final String? name;
  final String? userType;

  const ShopProfileUser({
    this.id,
    this.name,
    this.userType,
  });

  factory ShopProfileUser.fromJson(Map<String, dynamic> json) {
    return ShopProfileUser(
      id: _int(json['id']),
      name: _string(json['name']),
      userType: _string(json['user_type']),
    );
  }
}

String _firstNotEmpty(List<String?> values) {
  for (final value in values) {
    final clean = value?.trim();
    if (clean != null && clean.isNotEmpty) return clean;
  }
  return '';
}

String? _mediaUrl(dynamic value) {
  if (value is Map) {
    final map = Map<String, dynamic>.from(value);
    return _string(map['url']) ?? _string(map['resolved_url']) ?? _string(map['file_name']);
  }
  return _string(value);
}

String? _string(dynamic value) {
  final result = value?.toString().trim();
  return result == null || result.isEmpty ? null : result;
}

int? _int(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ?? double.tryParse(value.toString())?.toInt();
}
