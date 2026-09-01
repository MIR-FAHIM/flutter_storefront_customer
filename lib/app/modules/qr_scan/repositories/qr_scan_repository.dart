import 'dart:convert';

import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/shop_model.dart';
import 'package:ecom_user_flutter/app/repositories/product_rep.dart';
import 'package:ecom_user_flutter/models/ecom/product/shop_profile_model.dart';

class QrStorePayload {
  final String slug;
  final int? sellerId;

  const QrStorePayload({required this.slug, this.sellerId});
}

class QrScanRepository {
  Future<QrStorePayload> resolveQrCode(String qrData) async {
    final shopCode = _shopCodeFromQrData(qrData);
    if (shopCode != null) {
      return _resolveShopCode(shopCode);
    }

    final payload = parseQrCode(qrData);
    if (payload.sellerId != null) return payload;

    final response = await ProductRepository().getShop(
      params: {
        'slug': payload.slug,
        'status': 'active',
        'per_page': 1,
      },
    );
    if (response is! Map<String, dynamic> || response['status'] != 'success') {
      throw Exception('Store could not be found');
    }

    final model = ShopListResModel.fromJson(response);
    final shops = model.data?.data ?? const <Datum>[];
    Datum? matchedShop;
    for (final shop in shops) {
      if (shop.slug?.trim() == payload.slug) {
        matchedShop = shop;
        break;
      }
    }

    final sellerId = matchedShop?.userId ?? matchedShop?.user?.id;
    if (sellerId == null) throw Exception('Store seller could not be found');
    return QrStorePayload(slug: payload.slug, sellerId: sellerId);
  }

  Future<QrStorePayload> _resolveShopCode(String code) async {
    final response = await APIManager().get('${ApiClient.findShopByCode}$code');
    if (response is! Map<String, dynamic> || response['status'] != 'success') {
      throw Exception('No active store found for this code.');
    }

    final model = ShopProfileResponse.fromJson(response);
    final shop = model.data;
    final slug = shop?.slug?.trim() ?? '';
    final sellerId = shop?.userId;

    if (slug.isEmpty) throw Exception('Store slug is missing from shop profile');
    if (sellerId == null) throw Exception('Store seller could not be found');

    return QrStorePayload(slug: slug, sellerId: sellerId);
  }

  QrStorePayload parseQrCode(String qrData) {
    final raw = qrData.trim();
    if (raw.isEmpty) throw Exception('Invalid QR code format');

    final decoded = _decodeJson(raw);
    if (decoded != null) {
      final slug = _string(decoded['store_slug']) ??
          _string(decoded['slug']) ??
          _slugFromUrl(_string(decoded['url']) ?? '');
      if (slug == null || slug.isEmpty) {
        throw Exception('Store slug is missing from QR code');
      }
      return QrStorePayload(
        slug: slug,
        sellerId: _int(decoded['seller_id']),
      );
    }

    final uri = Uri.tryParse(raw);
    final sellerId = uri == null ? null : _int(uri.queryParameters['seller_id']);
    final slug = uri == null || !uri.hasScheme
        ? raw
        : _slugFromUrl(uri.path);
    if (slug!.isEmpty) throw Exception('Invalid QR code format');
    return QrStorePayload(slug: slug, sellerId: sellerId);
  }

  Map<String, dynamic>? _decodeJson(String value) {
    try {
      final json = jsonDecode(value);
      return json is Map ? Map<String, dynamic>.from(json) : null;
    } catch (_) {
      return null;
    }
  }

  String? _slugFromUrl(String value) {
    final path = value.split('?').first.split('#').first;
    final parts = path.split('/').where((part) => part.isNotEmpty).toList();
    return parts.isEmpty ? null : parts.last.trim();
  }

  String? _string(dynamic value) {
    final result = value?.toString().trim();
    return result == null || result.isEmpty ? null : result;
  }

  int? _int(dynamic value) => value == null ? null : int.tryParse(value.toString());

  String? _shopCodeFromQrData(String qrData) {
    final raw = qrData.trim();
    if (RegExp(r'^\d{6}$').hasMatch(raw)) return raw;

    final decoded = _decodeJson(raw);
    final jsonCode = decoded == null ? null : _string(decoded['code']);
    if (jsonCode != null && RegExp(r'^\d{6}$').hasMatch(jsonCode)) {
      return jsonCode;
    }

    final uri = Uri.tryParse(raw);
    final queryCode = uri == null ? null : _string(uri.queryParameters['code']);
    if (queryCode != null && RegExp(r'^\d{6}$').hasMatch(queryCode)) {
      return queryCode;
    }

    return null;
  }
}
