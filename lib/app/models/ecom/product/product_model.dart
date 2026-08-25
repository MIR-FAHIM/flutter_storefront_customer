import 'dart:convert';

ProductsResponse productsResponseFromJson(String source) {
  return ProductsResponse.fromJson(
    json.decode(source) as Map<String, dynamic>,
  );
}

String productsResponseToJson(ProductsResponse data) {
  return json.encode(data.toJson());
}

class ProductsResponse {
  final String status;
  final String message;
  final ProductsPage data;

  const ProductsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      status: _asString(json['status']),
      message: _asString(json['message']),
      data: ProductsPage.fromJson(
        _asMap(json['data']) ?? const <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }

  static ProductsResponse fromRawJson(String source) {
    return productsResponseFromJson(source);
  }

  String toRawJson() {
    return productsResponseToJson(this);
  }
}

class ProductsPage {
  final int currentPage;
  final List<ProductModel> items;

  final String? firstPageUrl;
  final int? from;
  final int lastPage;
  final String? lastPageUrl;
  final List<PaginationLink> links;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  const ProductsPage({
    required this.currentPage,
    required this.items,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory ProductsPage.fromJson(Map<String, dynamic> json) {
    return ProductsPage(
      currentPage: _asInt(json['current_page'], fallback: 1),
      items: _asList(json['data'])
          .map((item) {
        final map = _asMap(item);
        if (map == null) return null;
        return ProductModel.fromJson(map);
      })
          .whereType<ProductModel>()
          .toList(),
      firstPageUrl: _asNullableString(json['first_page_url']),
      from: _asNullableInt(json['from']),
      lastPage: _asInt(json['last_page'], fallback: 1),
      lastPageUrl: _asNullableString(json['last_page_url']),
      links: _asList(json['links'])
          .map((item) {
        final map = _asMap(item);
        if (map == null) return null;
        return PaginationLink.fromJson(map);
      })
          .whereType<PaginationLink>()
          .toList(),
      nextPageUrl: _asNullableString(json['next_page_url']),
      path: _asNullableString(json['path']),
      perPage: _asInt(json['per_page']),
      prevPageUrl: _asNullableString(json['prev_page_url']),
      to: _asNullableInt(json['to']),
      total: _asInt(json['total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': items.map((item) => item.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((item) => item.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }

  bool get hasMore => currentPage < lastPage;

  bool get isFirstPage => currentPage <= 1;

  bool get isLastPage => currentPage >= lastPage;
}

class PaginationLink {
  final String? url;
  final String label;
  final bool active;

  const PaginationLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PaginationLink.fromJson(Map<String, dynamic> json) {
    return PaginationLink(
      url: _asNullableString(json['url']),
      label: _asString(json['label']),
      active: _asBool(json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}

class ProductModel {
  final int id;
  final String? name;
  final String? addedBy;
  final int? userId;
  final int? shopId;
  final int? categoryId;
  final int? brandId;

  final String? photos;
  final String? thumbnailImg;
  final String? videoProvider;
  final String? videoLink;
  final dynamic tags;
  final String? description;

  final double unitPrice;
  final double? purchasePrice;

  final int variantProduct;
  final dynamic attributes;
  final dynamic choiceOptions;
  final dynamic colors;
  final dynamic variations;

  final bool todaysDeal;
  final bool published;
  final bool approved;
  final String? stockVisibilityState;
  final bool cashOnDelivery;
  final bool featured;
  final bool sellerFeatured;

  final int currentStock;
  final String? unit;
  final double? weight;
  final int minQty;
  final int? lowStockQuantity;

  final double? discount;
  final String? discountType;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;

  final double? startingBid;
  final DateTime? auctionStartDate;
  final DateTime? auctionEndDate;

  final double? tax;
  final String? taxType;
  final String? shippingType;
  final double shippingCost;
  final bool isQuantityMultiplied;
  final int? estShippingDays;

  final int numOfSale;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaImg;
  final String? pdf;
  final String? slug;
  final String? sku;

  final bool refundable;
  final int earnPoint;
  final double rating;

  final String? barcode;
  final bool showHome;
  final bool digital;
  final bool auctionProduct;

  final String? fileName;
  final String? filePath;
  final String? externalLink;
  final String? externalLinkBtn;
  final bool wholesaleProduct;
  final String? frequentlyBroughtSelectionType;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final MediaFile? primaryImage;
  final List<ProductGalleryImage> images;
  final ProductCategory? category;
  final ProductCategory? subCategory;
  final ProductBrand? brand;
  final dynamic productDiscount;
  final dynamic averageReview;
  final ProductShop? shop;

  const ProductModel({
    required this.id,
    this.name,
    this.addedBy,
    this.userId,
    this.shopId,
    this.categoryId,
    this.brandId,
    this.photos,
    this.thumbnailImg,
    this.videoProvider,
    this.videoLink,
    this.tags,
    this.description,
    required this.unitPrice,
    this.purchasePrice,
    required this.variantProduct,
    this.attributes,
    this.choiceOptions,
    this.colors,
    this.variations,
    required this.todaysDeal,
    required this.published,
    required this.approved,
    this.stockVisibilityState,
    required this.cashOnDelivery,
    required this.featured,
    required this.sellerFeatured,
    required this.currentStock,
    this.unit,
    this.weight,
    required this.minQty,
    this.lowStockQuantity,
    this.discount,
    this.discountType,
    this.discountStartDate,
    this.discountEndDate,
    this.startingBid,
    this.auctionStartDate,
    this.auctionEndDate,
    this.tax,
    this.taxType,
    this.shippingType,
    required this.shippingCost,
    required this.isQuantityMultiplied,
    this.estShippingDays,
    required this.numOfSale,
    this.metaTitle,
    this.metaDescription,
    this.metaImg,
    this.pdf,
    this.slug,
    this.sku,
    required this.refundable,
    required this.earnPoint,
    required this.rating,
    this.barcode,
    required this.showHome,
    required this.digital,
    required this.auctionProduct,
    this.fileName,
    this.filePath,
    this.externalLink,
    this.externalLinkBtn,
    required this.wholesaleProduct,
    this.frequentlyBroughtSelectionType,
    this.createdAt,
    this.updatedAt,
    this.primaryImage,
    required this.images,
    this.category,
    this.subCategory,
    this.brand,
    this.productDiscount,
    this.averageReview,
    this.shop,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: _asInt(json['id']),
      name: _asNullableString(json['name']),
      addedBy: _asNullableString(json['added_by']),
      userId: _asNullableInt(json['user_id']),
      shopId: _asNullableInt(json['shop_id']),
      categoryId: _asNullableInt(json['category_id']),
      brandId: _asNullableInt(json['brand_id']),
      photos: _asNullableString(json['photos']),
      thumbnailImg: _asNullableString(json['thumbnail_img']),
      videoProvider: _asNullableString(json['video_provider']),
      videoLink: _asNullableString(json['video_link']),
      tags: json['tags'],
      description: _asNullableString(json['description']),
      unitPrice: _asDouble(json['unit_price']),
      purchasePrice: _asNullableDouble(json['purchase_price']),
      variantProduct: _asInt(json['variant_product']),
      attributes: json['attributes'],
      choiceOptions: json['choice_options'],
      colors: json['colors'],
      variations: json['variations'],
      todaysDeal: _asBool(json['todays_deal']),
      published: _asBool(json['published']),
      approved: _asBool(json['approved']),
      stockVisibilityState: _asNullableString(json['stock_visibility_state']),
      cashOnDelivery: _asBool(json['cash_on_delivery']),
      featured: _asBool(json['featured']),
      sellerFeatured: _asBool(json['seller_featured']),
      currentStock: _asInt(json['current_stock']),
      unit: _asNullableString(json['unit']),
      weight: _asNullableDouble(json['weight']),
      minQty: _asInt(json['min_qty'], fallback: 1),
      lowStockQuantity: _asNullableInt(json['low_stock_quantity']),
      discount: _asNullableDouble(json['discount']),
      discountType: _asNullableString(json['discount_type']),
      discountStartDate: _asDate(json['discount_start_date']),
      discountEndDate: _asDate(json['discount_end_date']),
      startingBid: _asNullableDouble(json['starting_bid']),
      auctionStartDate: _asDate(json['auction_start_date']),
      auctionEndDate: _asDate(json['auction_end_date']),
      tax: _asNullableDouble(json['tax']),
      taxType: _asNullableString(json['tax_type']),
      shippingType: _asNullableString(json['shipping_type']),
      shippingCost: _asDouble(json['shipping_cost']),
      isQuantityMultiplied: _asBool(json['is_quantity_multiplied']),
      estShippingDays: _asNullableInt(json['est_shipping_days']),
      numOfSale: _asInt(json['num_of_sale']),
      metaTitle: _asNullableString(json['meta_title']),
      metaDescription: _asNullableString(json['meta_description']),
      metaImg: _asNullableString(json['meta_img']),
      pdf: _asNullableString(json['pdf']),
      slug: _asNullableString(json['slug']),
      sku: _asNullableString(json['sku']),
      refundable: _asBool(json['refundable']),
      earnPoint: _asInt(json['earn_point']),
      rating: _asDouble(json['rating']),
      barcode: _asNullableString(json['barcode']),
      showHome: _asBool(json['show_home']),
      digital: _asBool(json['digital']),
      auctionProduct: _asBool(json['auction_product']),
      fileName: _asNullableString(json['file_name']),
      filePath: _asNullableString(json['file_path']),
      externalLink: _asNullableString(json['external_link']),
      externalLinkBtn: _asNullableString(json['external_link_btn']),
      wholesaleProduct: _asBool(json['wholesale_product']),
      frequentlyBroughtSelectionType:
      _asNullableString(json['frequently_brought_selection_type']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
      primaryImage: _asMap(json['primary_image']) == null
          ? null
          : MediaFile.fromJson(_asMap(json['primary_image'])!),
      images: _asList(json['images'])
          .map((item) {
        final map = _asMap(item);
        if (map == null) return null;
        return ProductGalleryImage.fromJson(map);
      })
          .whereType<ProductGalleryImage>()
          .toList(),
      category: _asMap(json['category']) == null
          ? null
          : ProductCategory.fromJson(_asMap(json['category'])!),
      subCategory: _asMap(json['sub_category']) == null
          ? null
          : ProductCategory.fromJson(_asMap(json['sub_category'])!),
      brand: _asMap(json['brand']) == null
          ? null
          : ProductBrand.fromJson(_asMap(json['brand'])!),
      productDiscount: json['product_discount'],
      averageReview: json['average_review'],
      shop: _asMap(json['shop']) == null
          ? null
          : ProductShop.fromJson(_asMap(json['shop'])!),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'added_by': addedBy,
      'user_id': userId,
      'shop_id': shopId,
      'category_id': categoryId,
      'brand_id': brandId,
      'photos': photos,
      'thumbnail_img': thumbnailImg,
      'video_provider': videoProvider,
      'video_link': videoLink,
      'tags': tags,
      'description': description,
      'unit_price': unitPrice,
      'purchase_price': purchasePrice,
      'variant_product': variantProduct,
      'attributes': attributes,
      'choice_options': choiceOptions,
      'colors': colors,
      'variations': variations,
      'todays_deal': todaysDeal ? 1 : 0,
      'published': published ? 1 : 0,
      'approved': approved ? 1 : 0,
      'stock_visibility_state': stockVisibilityState,
      'cash_on_delivery': cashOnDelivery ? 1 : 0,
      'featured': featured ? 1 : 0,
      'seller_featured': sellerFeatured ? 1 : 0,
      'current_stock': currentStock,
      'unit': unit,
      'weight': weight,
      'min_qty': minQty,
      'low_stock_quantity': lowStockQuantity,
      'discount': discount,
      'discount_type': discountType,
      'discount_start_date': discountStartDate?.toIso8601String(),
      'discount_end_date': discountEndDate?.toIso8601String(),
      'starting_bid': startingBid,
      'auction_start_date': auctionStartDate?.toIso8601String(),
      'auction_end_date': auctionEndDate?.toIso8601String(),
      'tax': tax,
      'tax_type': taxType,
      'shipping_type': shippingType,
      'shipping_cost': shippingCost,
      'is_quantity_multiplied': isQuantityMultiplied ? 1 : 0,
      'est_shipping_days': estShippingDays,
      'num_of_sale': numOfSale,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_img': metaImg,
      'pdf': pdf,
      'slug': slug,
      'sku': sku,
      'refundable': refundable ? 1 : 0,
      'earn_point': earnPoint,
      'rating': rating,
      'barcode': barcode,
      'show_home': showHome ? 1 : 0,
      'digital': digital ? 1 : 0,
      'auction_product': auctionProduct ? 1 : 0,
      'file_name': fileName,
      'file_path': filePath,
      'external_link': externalLink,
      'external_link_btn': externalLinkBtn,
      'wholesale_product': wholesaleProduct ? 1 : 0,
      'frequently_brought_selection_type': frequentlyBroughtSelectionType,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'primary_image': primaryImage?.toJson(),
      'images': images.map((item) => item.toJson()).toList(),
      'category': category?.toJson(),
      'sub_category': subCategory?.toJson(),
      'brand': brand?.toJson(),
      'product_discount': productDiscount,
      'average_review': averageReview,
      'shop': shop?.toJson(),
    };
  }

  bool get hasDiscount {
    return discount != null && discount! > 0;
  }

  bool get isPercentDiscount {
    final type = discountType?.toLowerCase().trim() ?? '';
    return type == 'percent' || type == 'percentage' || type == '%';
  }

  double get discountedUnitPrice {
    if (!hasDiscount) return unitPrice;

    final value = discount ?? 0;

    final calculated = isPercentDiscount
        ? unitPrice - ((unitPrice * value) / 100)
        : unitPrice - value;

    if (calculated < 0) return 0;

    return calculated;
  }

  String get discountLabel {
    if (!hasDiscount) return '';

    final value = discount ?? 0;

    if (isPercentDiscount) {
      return '${_formatNumber(value)}% OFF';
    }

    return '৳ ${_formatNumber(value)} OFF';
  }

  String get mainPrice {
    return '৳ ${_formatNumber(discountedUnitPrice)}';
  }

  String get strokedPrice {
    if (!hasDiscount) return '';
    return '৳ ${_formatNumber(unitPrice)}';
  }

  String? imageUrl({required String baseUrl}) {
    return primaryImage?.resolvedUrl(baseUrl: baseUrl);
  }
}

class MediaFile {
  final int id;
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

  const MediaFile({
    required this.id,
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
      id: _asInt(json['id']),
      fileOriginalName: _asNullableString(json['file_original_name']),
      fileName: _asNullableString(json['file_name']),
      userId: _asNullableInt(json['user_id']),
      fileSize: _asNullableInt(json['file_size']),
      extension: _asNullableString(json['extension']),
      type: _asNullableString(json['type']),
      externalLink: json['external_link'],
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
      deletedAt: _asDate(json['deleted_at']),
      url: _asNullableString(json['url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_original_name': fileOriginalName,
      'file_name': fileName,
      'user_id': userId,
      'file_size': fileSize,
      'extension': extension,
      'type': type,
      'external_link': externalLink,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'url': url,
    };
  }

  String? resolvedUrl({required String baseUrl}) {
    final directUrl = url?.trim();

    if (directUrl != null && directUrl.isNotEmpty) {
      return directUrl;
    }

    final file = fileName?.trim();

    if (file == null || file.isEmpty) {
      return null;
    }

    if (file.startsWith('http://') || file.startsWith('https://')) {
      return file;
    }

    final cleanBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final cleanFile = file.startsWith('/') ? file.substring(1) : file;

    return '$cleanBase/$cleanFile';
  }
}

class ProductGalleryImage {
  final int id;
  final int? productId;
  final String? image;
  final String? altText;
  final int? sortOrder;
  final bool isPrimary;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductGalleryImage({
    required this.id,
    this.productId,
    this.image,
    this.altText,
    this.sortOrder,
    required this.isPrimary,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductGalleryImage.fromJson(Map<String, dynamic> json) {
    return ProductGalleryImage(
      id: _asInt(json['id']),
      productId: _asNullableInt(json['product_id']),
      image: _asNullableString(json['image']),
      altText: _asNullableString(json['alt_text']),
      sortOrder: _asNullableInt(json['sort_order']),
      isPrimary: _asBool(json['is_primary']),
      status: _asNullableString(json['status']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'image': image,
      'alt_text': altText,
      'sort_order': sortOrder,
      'is_primary': isPrimary,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ProductCategory {
  final int id;
  final int? parentId;
  final int? level;
  final String? name;
  final bool isActive;
  final int? orderLevel;
  final double? commisionRate;
  final String? banner;
  final String? icon;
  final String? coverImage;
  final bool featured;
  final bool top;
  final bool digital;
  final String? slug;
  final String? metaTitle;
  final String? metaDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductCategory({
    required this.id,
    this.parentId,
    this.level,
    this.name,
    required this.isActive,
    this.orderLevel,
    this.commisionRate,
    this.banner,
    this.icon,
    this.coverImage,
    required this.featured,
    required this.top,
    required this.digital,
    this.slug,
    this.metaTitle,
    this.metaDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: _asInt(json['id']),
      parentId: _asNullableInt(json['parent_id']),
      level: _asNullableInt(json['level']),
      name: _asNullableString(json['name']),
      isActive: _asBool(json['is_active']),
      orderLevel: _asNullableInt(json['order_level']),
      commisionRate: _asNullableDouble(json['commision_rate']),
      banner: _asNullableString(json['banner']),
      icon: _asNullableString(json['icon']),
      coverImage: _asNullableString(json['cover_image']),
      featured: _asBool(json['featured']),
      top: _asBool(json['top']),
      digital: _asBool(json['digital']),
      slug: _asNullableString(json['slug']),
      metaTitle: _asNullableString(json['meta_title']),
      metaDescription: _asNullableString(json['meta_description']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'level': level,
      'name': name,
      'is_active': isActive ? 1 : 0,
      'order_level': orderLevel,
      'commision_rate': commisionRate,
      'banner': banner,
      'icon': icon,
      'cover_image': coverImage,
      'featured': featured ? 1 : 0,
      'top': top ? 1 : 0,
      'digital': digital ? 1 : 0,
      'slug': slug,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ProductBrand {
  final int id;
  final String? name;
  final String? slug;
  final String? logo;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductBrand({
    required this.id,
    this.name,
    this.slug,
    this.logo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductBrand.fromJson(Map<String, dynamic> json) {
    return ProductBrand(
      id: _asInt(json['id']),
      name: _asNullableString(json['name']),
      slug: _asNullableString(json['slug']),
      logo: _asNullableString(json['logo']),
      status: _asNullableString(json['status']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logo': logo,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ProductShop {
  final int id;
  final int? userId;
  final String? name;
  final String? shopName;
  final String? slug;
  final String? description;
  final String? logo;
  final String? banner;
  final String? phone;
  final String? email;
  final String? address;
  final String? zone;
  final String? district;
  final String? area;
  final double? lat;
  final double? lon;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductShop({
    required this.id,
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
    this.createdAt,
    this.updatedAt,
  });

  factory ProductShop.fromJson(Map<String, dynamic> json) {
    return ProductShop(
      id: _asInt(json['id']),
      userId: _asNullableInt(json['user_id']),
      name: _asNullableString(json['name']),
      shopName: _asNullableString(json['shop_name']),
      slug: _asNullableString(json['slug']),
      description: _asNullableString(json['description']),
      logo: _asNullableString(json['logo']),
      banner: _asNullableString(json['banner']),
      phone: _asNullableString(json['phone']),
      email: _asNullableString(json['email']),
      address: _asNullableString(json['address']),
      zone: _asNullableString(json['zone']),
      district: _asNullableString(json['district']),
      area: _asNullableString(json['area']),
      lat: _asNullableDouble(json['lat']),
      lon: _asNullableDouble(json['lon']),
      status: _asNullableString(json['status']),
      createdAt: _asDate(json['created_at']),
      updatedAt: _asDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'shop_name': shopName,
      'slug': slug,
      'description': description,
      'logo': logo,
      'banner': banner,
      'phone': phone,
      'email': email,
      'address': address,
      'zone': zone,
      'district': district,
      'area': area,
      'lat': lat,
      'lon': lon,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

/// Helper methods

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return null;
}

List<dynamic> _asList(dynamic value) {
  if (value is List) return value;
  return const <dynamic>[];
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;

  final text = value.toString().trim();

  if (text.isEmpty || text.toLowerCase() == 'null') {
    return fallback;
  }

  return text;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text.toLowerCase() == 'null') {
    return null;
  }

  return text;
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;

  if (value is int) return value;

  if (value is double) return value.toInt();

  if (value is bool) return value ? 1 : 0;

  if (value is String) {
    return int.tryParse(value.trim()) ??
        double.tryParse(value.trim())?.toInt() ??
        fallback;
  }

  return fallback;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is double) return value.toInt();

  if (value is bool) return value ? 1 : 0;

  if (value is String) {
    final text = value.trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return int.tryParse(text) ?? double.tryParse(text)?.toInt();
  }

  return null;
}

double _asDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;

  if (value is double) return value;

  if (value is int) return value.toDouble();

  if (value is bool) return value ? 1 : 0;

  if (value is String) {
    return double.tryParse(value.trim()) ?? fallback;
  }

  return fallback;
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;

  if (value is double) return value;

  if (value is int) return value.toDouble();

  if (value is bool) return value ? 1 : 0;

  if (value is String) {
    final text = value.trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return double.tryParse(text);
  }

  return null;
}

bool _asBool(dynamic value) {
  if (value == null) return false;

  if (value is bool) return value;

  if (value is int) return value == 1;

  if (value is double) return value == 1;

  if (value is String) {
    final text = value.toLowerCase().trim();

    return text == '1' || text == 'true' || text == 'active' || text == 'yes';
  }

  return false;
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;

  if (value is DateTime) return value;

  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  if (value is String) {
    final text = value.trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return null;
    }

    return DateTime.tryParse(text);
  }

  return null;
}

String _formatNumber(double value) {
  if (value % 1 == 0) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(2);
}