// To parse this JSON data, do
//
// final categoryResModel = categoryResModelFromJson(jsonString);

import 'dart:convert';

CategoryResModel categoryResModelFromJson(String str) =>
    CategoryResModel.fromJson(json.decode(str) as Map<String, dynamic>);

String categoryResModelToJson(CategoryResModel data) =>
    json.encode(data.toJson());

class CategoryResModel {
  final String? status;
  final String? message;
  final CategoryPageData? data;

  const CategoryResModel({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryResModel.fromJson(Map<String, dynamic> json) {
    final rawData = json["data"];
    return CategoryResModel(
      status: json["status"] as String?,
      message: json["message"] as String?,
      data: rawData == null ? null : CategoryPageData.fromDynamic(rawData),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class CategoryPageData {
  final int? currentPage;
  final List<CategoryItem> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  const CategoryPageData({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory CategoryPageData.fromJson(Map<String, dynamic> json) => CategoryPageData(
    currentPage: _asInt(json["current_page"]),
    data: (json["data"] is List)
        ? (json["data"] as List)
            .whereType<Map>()
            .map((x) => CategoryItem.fromJson(Map<String, dynamic>.from(x)))
            .toList()
        : <CategoryItem>[],
    firstPageUrl: json["first_page_url"] as String?,
    from: _asInt(json["from"]),
    lastPage: _asInt(json["last_page"]),
    lastPageUrl: json["last_page_url"] as String?,
    links: (json["links"] is List)
        ? (json["links"] as List)
            .whereType<Map>()
            .map((x) => PageLink.fromJson(Map<String, dynamic>.from(x)))
            .toList()
        : <PageLink>[],
    nextPageUrl: json["next_page_url"] as String?,
    path: json["path"] as String?,
    perPage: _asInt(json["per_page"]),
    prevPageUrl: json["prev_page_url"] as String?,
    to: _asInt(json["to"]),
    total: _asInt(json["total"]),
  );

  factory CategoryPageData.fromDynamic(dynamic value) {
    if (value is List) {
      final items = value
          .whereType<Map>()
          .map((x) => CategoryItem.fromJson(Map<String, dynamic>.from(x)))
          .toList();
      return CategoryPageData(
        currentPage: 1,
        data: items,
        lastPage: 1,
        links: const <PageLink>[],
        perPage: items.length,
        total: items.length,
      );
    }

    if (value is Map) {
      return CategoryPageData.fromJson(Map<String, dynamic>.from(value));
    }

    return const CategoryPageData(data: <CategoryItem>[], links: <PageLink>[]);
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data.map((x) => x.toJson()).toList(),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links.map((x) => x.toJson()).toList(),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class CategoryItem {
  final int? id;
  final int? parentId;
  final int? level;
  final String? name;
  final int? orderLevel;
  final num? commisionRate;
  final MediaImage? banner;
  final String? icon;
  final String? coverImage;
  final int? featured;
  final int? top;
  final int? digital;
  final String? slug;
  final String? metaTitle;
  final String? metaDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryItem({
    this.id,
    this.parentId,
    this.level,
    this.name,
    this.orderLevel,
    this.commisionRate,
    this.banner,
    this.icon,
    this.coverImage,
    this.featured,
    this.top,
    this.digital,
    this.slug,
    this.metaTitle,
    this.metaDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
    id: _asInt(json["id"]),
    parentId: _asInt(json["parent_id"]),
    level: _asInt(json["level"]),
    name: json["name"] as String?,
    orderLevel: _asInt(json["order_level"]),
    commisionRate: _asNum(json["commision_rate"]),
    banner: _mediaImage(json["banner"]) ??
        _mediaImage(json["cover_image"]) ??
        _mediaImage(json["icon"]),
    icon: _mediaUrlOrValue(json["icon"]),
    coverImage: _mediaUrlOrValue(json["cover_image"]),
    featured: _asInt(json["featured"]),
    top: _asInt(json["top"]),
    digital: _asInt(json["digital"]),
    slug: json["slug"] as String?,
    metaTitle: json["meta_title"] as String?,
    metaDescription: json["meta_description"] as String?,
    createdAt: _asDate(json["created_at"]),
    updatedAt: _asDate(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "level": level,
    "name": name,
    "order_level": orderLevel,
    "commision_rate": commisionRate,
    "banner": banner?.toJson(),
    "icon": icon,
    "cover_image": coverImage,
    "featured": featured,
    "top": top,
    "digital": digital,
    "slug": slug,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class MediaImage {
  final int? id;
  final String? fileOriginalName;
  final String? fileName;
  final int? userId;
  final int? fileSize;
  final String? extension;
  final String? type;
  final dynamic externalLink;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? url;

  const MediaImage({
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

  factory MediaImage.fromJson(Map<String, dynamic> json) => MediaImage(
    id: _asInt(json["id"]),
    fileOriginalName: json["file_original_name"] as String?,
    fileName: json["file_name"] as String?,
    userId: _asInt(json["user_id"]),
    fileSize: _asInt(json["file_size"]),
    extension: json["extension"] as String?,
    type: json["type"] as String?,
    externalLink: json["external_link"],
    createdAt: _asDate(json["created_at"]),
    updatedAt: _asDate(json["updated_at"]),
    deletedAt: _asDate(json["deleted_at"]),
    url: json["url"] as String?,
  );

  Map<String, dynamic> toJson() => {
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
    "deleted_at": deletedAt?.toIso8601String(),
    "url": url,
  };

  String? resolvedUrl({required String baseUrl}) {
    if (url != null && url!.trim().isNotEmpty) return url;
    if (fileName == null || fileName!.trim().isEmpty) return null;
    final b = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final f = fileName!.startsWith('/') ? fileName! : '/$fileName';
    return "$b$f";
  }
}

class PageLink {
  final String? url;
  final String? label;
  final bool? active;

  const PageLink({
    this.url,
    this.label,
    this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) => PageLink(
    url: json["url"] as String?,
    label: json["label"] as String?,
    active: _asBool(json["active"]),
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

/// -------- Helpers (defensive parsing) --------

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

num? _asNum(dynamic v) {
  if (v == null) return null;
  if (v is num) return v;
  if (v is String) return num.tryParse(v);
  return null;
}

bool? _asBool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is int) return v == 1;
  if (v is String) {
    final s = v.toLowerCase().trim();
    if (s == "true" || s == "1") return true;
    if (s == "false" || s == "0") return false;
  }
  return null;
}

DateTime? _asDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}

MediaImage? _mediaImage(dynamic value) {
  if (value is Map) {
    return MediaImage.fromJson(Map<String, dynamic>.from(value));
  }
  return null;
}

String? _mediaUrlOrValue(dynamic value) {
  if (value == null) return null;
  if (value is Map) {
    final map = Map<String, dynamic>.from(value);
    return map["url"]?.toString() ?? map["file_name"]?.toString();
  }
  return value.toString();
}
