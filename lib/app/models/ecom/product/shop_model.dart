import 'dart:convert';

ShopListResModel shopListResModelFromJson(String str) =>
    ShopListResModel.fromJson(json.decode(str));

String shopListResModelToJson(ShopListResModel data) =>
    json.encode(data.toJson());

class ShopListResModel {
  String? status;
  String? message;
  ShopItem? data;

  ShopListResModel({
    this.status,
    this.message,
    this.data,
  });

  factory ShopListResModel.fromJson(Map<String, dynamic> json) {
    return ShopListResModel(
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
      data: json["data"] != null ? ShopItem.fromJson(json["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class ShopItem {
  int? currentPage;
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  ShopItem({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      currentPage: json["current_page"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(
              json["data"].map((x) => Datum.fromJson(x)),
            ),
      firstPageUrl: json["first_page_url"]?.toString(),
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"]?.toString(),
      links: json["links"] == null
          ? []
          : List<Link>.from(
              json["links"].map((x) => Link.fromJson(x)),
            ),
      nextPageUrl: json["next_page_url"],
      path: json["path"]?.toString(),
      perPage: json["per_page"] is int
          ? json["per_page"]
          : int.tryParse(json["per_page"].toString()),
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "current_page": currentPage,
      "data": data?.map((x) => x.toJson()).toList(),
      "first_page_url": firstPageUrl,
      "from": from,
      "last_page": lastPage,
      "last_page_url": lastPageUrl,
      "links": links?.map((x) => x.toJson()).toList(),
      "next_page_url": nextPageUrl,
      "path": path,
      "per_page": perPage,
      "prev_page_url": prevPageUrl,
      "to": to,
      "total": total,
    };
  }
}

class Datum {
  int? id;
  int? userId;
  String? name;
  String? shopName;
  String? slug;
  String? description;
  MediaFile? logo;
  MediaFile? banner;
  String? phone;
  String? email;
  String? address;
  dynamic zone;
  dynamic district;
  dynamic area;
  dynamic lat;
  dynamic lon;
  String? status;
  ShopRating? rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  Datum({
    this.id,
    this.userId,
    this.name,
    this.shopName,
    this.slug,
    this.description,
    this.logo,
    this.banner,
    this.phone,
    this.email,
    this.address,
    this.zone,
    this.district,
    this.area,
    this.lat,
    this.lon,
    this.status,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      userId: json["user_id"],
      name: json["name"]?.toString(),
      shopName: json["shop_name"]?.toString(),
      slug: json["slug"]?.toString(),
      description: json["description"]?.toString(),
      logo: json["logo"] != null ? MediaFile.fromJson(json["logo"]) : null,
      banner:
          json["banner"] != null ? MediaFile.fromJson(json["banner"]) : null,
      phone: json["phone"]?.toString(),
      email: json["email"]?.toString(),
      address: json["address"]?.toString(),
      zone: json["zone"],
      district: json["district"],
      area: json["area"],
      lat: json["lat"],
      lon: json["lon"],
      status: json["status"]?.toString(),
      rating: json["rating"] is Map
          ? ShopRating.fromJson(Map<String, dynamic>.from(json["rating"]))
          : null,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
    );
  }

  num get averageReviewRating => rating?.averageReviewRating ?? 0;
  int get totalReviews => rating?.totalReviews ?? 0;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "name": name,
      "shop_name": shopName,
      "slug": slug,
      "description": description,
      "logo": logo?.toJson(),
      "banner": banner?.toJson(),
      "phone": phone,
      "email": email,
      "address": address,
      "zone": zone,
      "district": district,
      "area": area,
      "lat": lat,
      "lon": lon,
      "status": status,
      "rating": rating?.toJson(),
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "user": user?.toJson(),
    };
  }
}

class ShopRating {
  num? averageReviewRating;
  int? totalReviews;

  ShopRating({
    this.averageReviewRating,
    this.totalReviews,
  });

  factory ShopRating.fromJson(Map<String, dynamic> json) {
    return ShopRating(
      averageReviewRating: _asNum(json["average_review_rating"]),
      totalReviews: _asInt(json["total_reviews"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "average_review_rating": averageReviewRating,
      "total_reviews": totalReviews,
    };
  }
}

class MediaFile {
  int? id;
  String? fileOriginalName;
  String? fileName;
  int? userId;
  int? fileSize;
  String? extension;
  String? type;
  dynamic externalLink;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? url;

  MediaFile({
    this.id,
    this.fileOriginalName,
    this.fileName,
    this.userId,
    this.fileSize,
    this.extension,
    this.type,
    this.externalLink,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.url,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json["id"],
      fileOriginalName: json["file_original_name"]?.toString(),
      fileName: json["file_name"]?.toString(),
      userId: json["user_id"],
      fileSize: json["file_size"],
      extension: json["extension"]?.toString(),
      type: json["type"]?.toString(),
      externalLink: json["external_link"],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      deletedAt: json["deleted_at"],
      url: json["url"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "file_original_name": fileOriginalName,
      "file_name": fileName,
      "user_id": userId,
      "file_size": fileSize,
      "extension": extension,
      "type": type,
      "external_link": externalLink,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "deleted_at": deletedAt,
      "url": url,
    };
  }
}

num? _asNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString());
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.toInt();
}

class User {
  int? id;
  dynamic referredBy;
  dynamic provider;
  dynamic providerId;
  String? userType;
  String? name;
  String? email;
  DateTime? emailVerifiedAt;
  dynamic deviceToken;
  String? avatar;
  String? avatarOriginal;
  String? address;
  String? country;
  String? state;
  String? city;
  String? postalCode;
  String? phone;
  int? balance;
  int? banned;
  dynamic referralCode;
  dynamic customerPackageId;
  int? remainingUploads;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.referredBy,
    this.provider,
    this.providerId,
    this.userType,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.deviceToken,
    this.avatar,
    this.avatarOriginal,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
    this.balance,
    this.banned,
    this.referralCode,
    this.customerPackageId,
    this.remainingUploads,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      referredBy: json["referred_by"],
      provider: json["provider"],
      providerId: json["provider_id"],
      userType: json["user_type"]?.toString(),
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      emailVerifiedAt: json["email_verified_at"] != null
          ? DateTime.tryParse(json["email_verified_at"])
          : null,
      deviceToken: json["device_token"],
      avatar: json["avatar"]?.toString(),
      avatarOriginal: json["avatar_original"]?.toString(),
      address: json["address"]?.toString(),
      country: json["country"]?.toString(),
      state: json["state"]?.toString(),
      city: json["city"]?.toString(),
      postalCode: json["postal_code"]?.toString(),
      phone: json["phone"]?.toString(),
      balance: json["balance"],
      banned: json["banned"],
      referralCode: json["referral_code"],
      customerPackageId: json["customer_package_id"],
      remainingUploads: json["remaining_uploads"],
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "referred_by": referredBy,
      "provider": provider,
      "provider_id": providerId,
      "user_type": userType,
      "name": name,
      "email": email,
      "email_verified_at": emailVerifiedAt?.toIso8601String(),
      "device_token": deviceToken,
      "avatar": avatar,
      "avatar_original": avatarOriginal,
      "address": address,
      "country": country,
      "state": state,
      "city": city,
      "postal_code": postalCode,
      "phone": phone,
      "balance": balance,
      "banned": banned,
      "referral_code": referralCode,
      "customer_package_id": customerPackageId,
      "remaining_uploads": remainingUploads,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json["url"]?.toString(),
      label: json["label"]?.toString(),
      active: json["active"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "label": label,
      "active": active,
    };
  }
}
