class BakiLedgerResponse {
  final String status;
  final String message;
  final BakiLedgerData? data;

  BakiLedgerResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BakiLedgerResponse.fromJson(Map<String, dynamic> json) {
    return BakiLedgerResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? BakiLedgerData.fromJson(json['data']) : null,
    );
  }
}

class BakiLedgerData {
  final CustomerInfo? customer;
  final int totalBaki;
  final List<BakiLedgerHistory> ledgerHistory;

  BakiLedgerData({
    this.customer,
    required this.totalBaki,
    required this.ledgerHistory,
  });

  factory BakiLedgerData.fromJson(Map<String, dynamic> json) {
    return BakiLedgerData(
      customer: json['customer'] != null ? CustomerInfo.fromJson(json['customer']) : null,
      totalBaki: json['total_baki'] ?? 0,
      ledgerHistory: (json['ledger_history'] as List?)
              ?.map((e) => BakiLedgerHistory.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CustomerInfo {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;

  CustomerInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
    );
  }
}

class BakiLedgerHistory {
  final int id;
  final int shopId;
  final int sellerId;
  final int customerId;
  final int? orderId;
  final String type; // 'DUE' or 'PAYMENT'
  final int amount;
  final int paidAmount;
  final int dueAmount;
  final int runningBalance;
  final String? paymentMethod;
  final String? dueDate;
  final String? note;
  final String? createdAt;
  final BakiOrderInfo? order;

  BakiLedgerHistory({
    required this.id,
    required this.shopId,
    required this.sellerId,
    required this.customerId,
    this.orderId,
    required this.type,
    required this.amount,
    required this.paidAmount,
    required this.dueAmount,
    required this.runningBalance,
    this.paymentMethod,
    this.dueDate,
    this.note,
    this.createdAt,
    this.order,
  });

  factory BakiLedgerHistory.fromJson(Map<String, dynamic> json) {
    return BakiLedgerHistory(
      id: json['id'] ?? 0,
      shopId: json['shop_id'] ?? 0,
      sellerId: json['seller_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      orderId: json['order_id'],
      type: json['type'] ?? '',
      amount: json['amount'] ?? 0,
      paidAmount: json['paid_amount'] ?? 0,
      dueAmount: json['due_amount'] ?? 0,
      runningBalance: json['running_balance'] ?? 0,
      paymentMethod: json['payment_method'],
      dueDate: json['due_date'],
      note: json['note'],
      createdAt: json['created_at'],
      order: json['order'] != null ? BakiOrderInfo.fromJson(json['order']) : null,
    );
  }
}

class BakiOrderInfo {
  final int id;
  final String orderNumber;
  final int total;
  final int paidAmount;
  final int dueAmount;

  BakiOrderInfo({
    required this.id,
    required this.orderNumber,
    required this.total,
    required this.paidAmount,
    required this.dueAmount,
  });

  factory BakiOrderInfo.fromJson(Map<String, dynamic> json) {
    return BakiOrderInfo(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      total: json['total'] ?? 0,
      paidAmount: json['paid_amount'] ?? 0,
      dueAmount: json['due_amount'] ?? 0,
    );
  }
}
