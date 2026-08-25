class CheckoutSuccessResponse {
  final String? status;
  final String? message;
  final CheckoutSuccessData? data;

  CheckoutSuccessResponse({
     this.status,
     this.message,
     this.data,
  });

  bool get isSuccess => status!.toLowerCase() == 'success';

  int get totalOrders => data?.totalOrders ?? 0;

  num get grandTotal => data?.totalPayable ?? 0;

  num get grandSubtotal => data?.subtotal ?? 0;

  num get grandShippingFee => data?.shippingFee ?? 0;

  num get grandDiscount {
    return data?.orders.fold<num>(
      0,
          (sum, order) => sum + order.discount,
    ) ??
        0;
  }

  String get firstOrderNumber {
    final orders = data?.orders ?? [];
    if (orders.isEmpty) return '';
    return orders.first.orderNumber;
  }

  factory CheckoutSuccessResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map
          ? CheckoutSuccessData.fromJson(
        Map<String, dynamic>.from(json['data']),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CheckoutSuccessData {
  final String paymentGroupId;
  final List<int> orderIds;
  final int totalOrders;
  final num subtotal;
  final num shippingFee;
  final num totalPayable;
  final List<CheckoutSuccessOrder> orders;

  CheckoutSuccessData({
    required this.paymentGroupId,
    required this.orderIds,
    required this.totalOrders,
    required this.subtotal,
    required this.shippingFee,
    required this.totalPayable,
    required this.orders,
  });

  factory CheckoutSuccessData.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessData(
      paymentGroupId: json['payment_group_id']?.toString() ?? '',
      orderIds: json['order_ids'] is List
          ? (json['order_ids'] as List).map((e) => _toInt(e)).toList()
          : <int>[],
      totalOrders: _toInt(json['total_orders']),
      subtotal: _toNum(json['subtotal']),
      shippingFee: _toNum(json['shipping_fee']),
      totalPayable: _toNum(json['total_payable']),
      orders: json['orders'] is List
          ? (json['orders'] as List)
          .whereType<Map>()
          .map(
            (e) => CheckoutSuccessOrder.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList()
          : <CheckoutSuccessOrder>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_group_id': paymentGroupId,
      'order_ids': orderIds,
      'total_orders': totalOrders,
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'total_payable': totalPayable,
      'orders': orders.map((e) => e.toJson()).toList(),
    };
  }
}

class CheckoutSuccessOrder {
  final int id;
  final int userId;
  final String orderNumber;
  final String paymentGroupId;
  final String status;
  final String paymentStatus;
  final String customerName;
  final String customerPhone;
  final String shippingAddress;
  final CheckoutLocation? zone;
  final CheckoutLocation? district;
  final String? area;
  final String? lat;
  final String? lon;
  final num subtotal;
  final num shippingFee;
  final num discount;
  final num total;
  final String note;
  final String platform;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CheckoutSuccessItem> items;

  CheckoutSuccessOrder({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.paymentGroupId,
    required this.status,
    required this.paymentStatus,
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.zone,
    required this.district,
    required this.area,
    required this.lat,
    required this.lon,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
    required this.note,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory CheckoutSuccessOrder.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessOrder(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      orderNumber: json['order_number']?.toString() ?? '',
      paymentGroupId: json['payment_group_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      shippingAddress: json['shipping_address']?.toString() ?? '',
      zone: json['zone'] is Map
          ? CheckoutLocation.fromJson(
        Map<String, dynamic>.from(json['zone']),
      )
          : null,
      district: json['district'] is Map
          ? CheckoutLocation.fromJson(
        Map<String, dynamic>.from(json['district']),
      )
          : null,
      area: json['area']?.toString(),
      lat: json['lat']?.toString(),
      lon: json['lon']?.toString(),
      subtotal: _toNum(json['subtotal']),
      shippingFee: _toNum(json['shipping_fee']),
      discount: _toNum(json['discount']),
      total: _toNum(json['total']),
      note: json['note']?.toString() ?? '',
      platform: json['platform']?.toString() ?? '',
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
      items: json['items'] is List
          ? (json['items'] as List)
          .whereType<Map>()
          .map(
            (e) => CheckoutSuccessItem.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList()
          : <CheckoutSuccessItem>[],
    );
  }

  String get zoneName => zone?.name ?? '';

  String get districtName => district?.name ?? '';

  bool get isPaid => paymentStatus.toLowerCase() == 'paid';

  bool get isPending => status.toLowerCase() == 'pending';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'payment_group_id': paymentGroupId,
      'status': status,
      'payment_status': paymentStatus,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'shipping_address': shippingAddress,
      'zone': zone?.toJson(),
      'district': district?.toJson(),
      'area': area,
      'lat': lat,
      'lon': lon,
      'subtotal': subtotal,
      'shipping_fee': shippingFee,
      'discount': discount,
      'total': total,
      'note': note,
      'platform': platform,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class CheckoutLocation {
  final int id;
  final int divisionId;
  final String name;
  final String bnName;
  final String lat;
  final String lon;
  final String url;

  CheckoutLocation({
    required this.id,
    required this.divisionId,
    required this.name,
    required this.bnName,
    required this.lat,
    required this.lon,
    required this.url,
  });

  factory CheckoutLocation.fromJson(Map<String, dynamic> json) {
    return CheckoutLocation(
      id: _toInt(json['id']),
      divisionId: _toInt(json['division_id']),
      name: json['name']?.toString() ?? '',
      bnName: json['bn_name']?.toString() ?? '',
      lat: json['lat']?.toString() ?? '',
      lon: json['lon']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'division_id': divisionId,
      'name': name,
      'bn_name': bnName,
      'lat': lat,
      'lon': lon,
      'url': url,
    };
  }
}

class CheckoutSuccessItem {
  final int id;
  final int orderId;
  final int productId;
  final int shopId;
  final String productName;
  final String? sku;
  final num unitPrice;
  final int qty;
  final num lineTotal;
  final String status;
  final int isSettleWithSeller;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CheckoutSuccessItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.shopId,
    required this.productName,
    required this.sku,
    required this.unitPrice,
    required this.qty,
    required this.lineTotal,
    required this.status,
    required this.isSettleWithSeller,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CheckoutSuccessItem.fromJson(Map<String, dynamic> json) {
    return CheckoutSuccessItem(
      id: _toInt(json['id']),
      orderId: _toInt(json['order_id']),
      productId: _toInt(json['product_id']),
      shopId: _toInt(json['shop_id']),
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      unitPrice: _toNum(json['unit_price']),
      qty: _toInt(json['qty']),
      lineTotal: _toNum(json['line_total']),
      status: json['status']?.toString() ?? '',
      isSettleWithSeller: _toInt(json['is_settle_with_seller']),
      createdAt: _toDate(json['created_at']),
      updatedAt: _toDate(json['updated_at']),
    );
  }

  num get calculatedLineTotal => unitPrice * qty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'shop_id': shopId,
      'product_name': productName,
      'sku': sku,
      'unit_price': unitPrice,
      'qty': qty,
      'line_total': lineTotal,
      'status': status,
      'is_settle_with_seller': isSettleWithSeller,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

num _toNum(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value;

  final cleanedValue = value.toString().replaceAll(',', '').trim();
  return num.tryParse(cleanedValue) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();

  final cleanedValue = value.toString().replaceAll(',', '').trim();
  return int.tryParse(cleanedValue) ?? 0;
}

DateTime? _toDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}