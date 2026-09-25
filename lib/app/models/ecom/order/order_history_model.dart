class OrderHistoryResModel {
  const OrderHistoryResModel({this.status, this.message, this.data});

  final String? status;
  final String? message;
  final OrderHistoryPage? data;

  factory OrderHistoryResModel.fromJson(Map<String, dynamic> json) {
    final data = _toMap(json['data']);
    return OrderHistoryResModel(
      status: _toString(json['status']),
      message: _toString(json['message']),
      data: data == null ? null : OrderHistoryPage.fromJson(data),
    );
  }
}

class OrderHistoryPage {
  const OrderHistoryPage({
    this.currentPage,
    this.items = const [],
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links = const [],
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  final int? currentPage;
  final List<OrderHistoryItem> items;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<OrderHistoryLink> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  factory OrderHistoryPage.fromJson(Map<String, dynamic> json) {
    return OrderHistoryPage(
      currentPage: _toInt(json['current_page']),
      items: _models(json['data'], OrderHistoryItem.fromJson),
      firstPageUrl: _toString(json['first_page_url']),
      from: _toInt(json['from']),
      lastPage: _toInt(json['last_page']),
      lastPageUrl: _toString(json['last_page_url']),
      links: _models(json['links'], OrderHistoryLink.fromJson),
      nextPageUrl: _toString(json['next_page_url']),
      path: _toString(json['path']),
      perPage: _toInt(json['per_page']),
      prevPageUrl: _toString(json['prev_page_url']),
      to: _toInt(json['to']),
      total: _toInt(json['total']),
    );
  }
}

class OrderHistoryLink {
  const OrderHistoryLink({this.url, this.label, this.page, this.active});

  final String? url;
  final String? label;
  final int? page;
  final bool? active;

  factory OrderHistoryLink.fromJson(Map<String, dynamic> json) {
    return OrderHistoryLink(
      url: _toString(json['url']),
      label: _toString(json['label']),
      page: _toInt(json['page']),
      active: _toBool(json['active']),
    );
  }
}

class OrderHistoryItem {
  const OrderHistoryItem({
    this.id,
    this.userId,
    this.orderNumber,
    this.paymentGroupId,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.orderType,
    this.customerName,
    this.customerPhone,
    this.shippingAddress,
    this.zone,
    this.district,
    this.area,
    this.lat,
    this.lon,
    this.subtotal,
    this.shippingFee,
    this.discount,
    this.total,
    this.paidAmount,
    this.dueAmount,
    this.dueDate,
    this.note,
    this.platform,
    this.userAddressId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.shopName,
    this.totalItems,
    this.shopId,
    this.shop,
    this.items = const [],
    this.userAddress,
  });

  final int? id;
  final int? userId;
  final String? orderNumber;
  final String? paymentGroupId;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? orderType;
  final String? customerName;
  final String? customerPhone;
  final String? shippingAddress;
  final String? zone;
  final String? district;
  final String? area;
  final String? lat;
  final String? lon;
  final double? subtotal;
  final int? totalItems;
  final double? shippingFee;
  final double? discount;
  final double? total;
  final double? paidAmount;
  final double? dueAmount;
  final String? dueDate;
  final String? note;
  final String? platform;
  final int? userAddressId;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? shopName;
  final int? shopId;
  final OrderHistoryShop? shop;
  final List<OrderHistoryLineItem> items;
  final OrderHistoryUserAddress? userAddress;



  factory OrderHistoryItem.fromJson(Map<String, dynamic> json) {
    final shop = _toMap(json['shop']);
    final userAddress = _toMap(json['user_address']);
    return OrderHistoryItem(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      orderNumber: _toString(json['order_number']),
      paymentGroupId: _toString(json['payment_group_id']),
      status: _toString(json['status']),
      paymentStatus: _toString(json['payment_status']),
      paymentMethod: _toString(json['payment_method']),
      orderType: _toString(json['order_type']),
      customerName: _toString(json['customer_name']),
      customerPhone: _toString(json['customer_phone']),
      shippingAddress: _toString(json['shipping_address']),
      zone: _toString(json['zone']),
      district: _toString(json['district']),
      area: _toString(json['area']),
      lat: _toString(json['lat']),
      lon: _toString(json['lon']),
      subtotal: _toDouble(json['subtotal']),
      shippingFee: _toDouble(json['shipping_fee']),
      discount: _toDouble(json['discount']),
      totalItems: _toInt(json['total_items']),
      total: _toDouble(json['total']),
      paidAmount: _toDouble(json['paid_amount']),
      dueAmount: _toDouble(json['due_amount']),
      dueDate: _toString(json['due_date']),
      note: _toString(json['note']),
      platform: _toString(json['platform']),
      userAddressId: _toInt(json['user_address_id']),
      isActive: _toInt(json['is_active']),
      createdAt: _toString(json['created_at']),
      updatedAt: _toString(json['updated_at']),
      shopName: _toString(json['shop_name']),
      shopId: _toInt(json['shop_id']),
      shop: shop == null ? null : OrderHistoryShop.fromJson(shop),
      items: _models(json['items'], OrderHistoryLineItem.fromJson),
      userAddress: userAddress == null
          ? null
          : OrderHistoryUserAddress.fromJson(userAddress),
    );
  }
}

class OrderHistoryLineItem {
  const OrderHistoryLineItem({
    this.id,
    this.orderId,
    this.productId,
    this.shopId,
    this.productName,
    this.sku,
    this.unitPrice,
    this.qty,
    this.lineTotal,
    this.status,
    this.isSettleWithSeller,
    this.createdAt,
    this.updatedAt,
    this.shop,
  });

  final int? id;
  final int? orderId;
  final int? productId;
  final int? shopId;
  final String? productName;
  final String? sku;
  final double? unitPrice;
  final int? qty;
  final double? lineTotal;
  final String? status;
  final int? isSettleWithSeller;
  final String? createdAt;
  final String? updatedAt;
  final OrderHistoryShop? shop;

  factory OrderHistoryLineItem.fromJson(Map<String, dynamic> json) {
    final shop = _toMap(json['shop']);
    return OrderHistoryLineItem(
      id: _toInt(json['id']),
      orderId: _toInt(json['order_id']),
      productId: _toInt(json['product_id']),
      shopId: _toInt(json['shop_id']),
      productName: _toString(json['product_name']),
      sku: _toString(json['sku']),
      unitPrice: _toDouble(json['unit_price']),
      qty: _toInt(json['qty']),
      lineTotal: _toDouble(json['line_total']),
      status: _toString(json['status']),
      isSettleWithSeller: _toInt(json['is_settle_with_seller']),
      createdAt: _toString(json['created_at']),
      updatedAt: _toString(json['updated_at']),
      shop: shop == null ? null : OrderHistoryShop.fromJson(shop),
    );
  }
}

class OrderHistoryShop {
  const OrderHistoryShop({
    this.id,
    this.userId,
    this.name,
    this.shopName,
    this.slug,
    this.code,
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
    this.productLimit,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? userId;
  final String? name;
  final String? shopName;
  final String? slug;
  final String? code;
  final String? description;
  final String? logo;
  final String? banner;
  final String? phone;
  final String? email;
  final String? address;
  final String? zone;
  final String? district;
  final String? area;
  final String? lat;
  final String? lon;
  final String? status;
  final int? productLimit;
  final String? createdAt;
  final String? updatedAt;

  String? get displayName => shopName ?? name;

  factory OrderHistoryShop.fromJson(Map<String, dynamic> json) {
    return OrderHistoryShop(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      name: _toString(json['name']),
      shopName: _toString(json['shop_name']),
      slug: _toString(json['slug']),
      code: _toString(json['code']),
      description: _toString(json['description']),
      logo: _mediaValue(json['logo']),
      banner: _mediaValue(json['banner']),
      phone: _toString(json['phone']),
      email: _toString(json['email']),
      address: _toString(json['address']),
      zone: _toString(json['zone']),
      district: _toString(json['district']),
      area: _toString(json['area']),
      lat: _toString(json['lat']),
      lon: _toString(json['lon']),
      status: _toString(json['status']),
      productLimit: _toInt(json['product_limit']),
      createdAt: _toString(json['created_at']),
      updatedAt: _toString(json['updated_at']),
    );
  }
}

class OrderHistoryUserAddress {
  const OrderHistoryUserAddress({
    this.id,
    this.name,
    this.userId,
    this.mobile,
    this.address,
    this.district,
    this.division,
    this.area,
    this.house,
    this.flat,
    this.lat,
    this.lon,
    this.note,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String? name;
  final int? userId;
  final String? mobile;
  final String? address;
  final OrderHistoryDistrict? district;
  final OrderHistoryDivision? division;
  final String? area;
  final String? house;
  final String? flat;
  final String? lat;
  final String? lon;
  final String? note;
  final bool? status;
  final String? createdAt;
  final String? updatedAt;

  factory OrderHistoryUserAddress.fromJson(Map<String, dynamic> json) {
    final district = _toMap(json['district']);
    final division = _toMap(json['division']);
    return OrderHistoryUserAddress(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      userId: _toInt(json['user_id']),
      mobile: _toString(json['mobile']),
      address: _toString(json['address']),
      district:
          district == null ? null : OrderHistoryDistrict.fromJson(district),
      division:
          division == null ? null : OrderHistoryDivision.fromJson(division),
      area: _toString(json['area']),
      house: _toString(json['house']),
      flat: _toString(json['flat']),
      lat: _toString(json['lat']),
      lon: _toString(json['lon']),
      note: _toString(json['note']),
      status: _toBool(json['status']),
      createdAt: _toString(json['created_at']),
      updatedAt: _toString(json['updated_at']),
    );
  }
}

class OrderHistoryDistrict {
  const OrderHistoryDistrict({
    this.id,
    this.divisionId,
    this.name,
    this.bnName,
    this.lat,
    this.lon,
    this.url,
  });

  final int? id;
  final int? divisionId;
  final String? name;
  final String? bnName;
  final String? lat;
  final String? lon;
  final String? url;

  factory OrderHistoryDistrict.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDistrict(
      id: _toInt(json['id']),
      divisionId: _toInt(json['division_id']),
      name: _toString(json['name']),
      bnName: _toString(json['bn_name']),
      lat: _toString(json['lat']),
      lon: _toString(json['lon']),
      url: _toString(json['url']),
    );
  }
}

class OrderHistoryDivision {
  const OrderHistoryDivision({this.id, this.name, this.bnName, this.url});

  final int? id;
  final String? name;
  final String? bnName;
  final String? url;

  factory OrderHistoryDivision.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDivision(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      bnName: _toString(json['bn_name']),
      url: _toString(json['url']),
    );
  }
}

List<T> _models<T>(dynamic value, T Function(Map<String, dynamic>) parser) {
  if (value is! List) return const [];
  return value
      .map(_toMap)
      .whereType<Map<String, dynamic>>()
      .map(parser)
      .toList();
}

Map<String, dynamic>? _toMap(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : null;
}

String? _toString(dynamic value) => value?.toString();

String? _mediaValue(dynamic value) {
  if (value == null) return null;
  if (value is Map) return _toString(value['url'] ?? value['id']);
  return value.toString();
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ??
      double.tryParse(value.toString())?.toInt();
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final normalized = value.toString().trim().toLowerCase();
  if (normalized == 'true' || normalized == '1') return true;
  if (normalized == 'false' || normalized == '0') return false;
  return null;
}
