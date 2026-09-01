import 'package:ecom_user_flutter/app/repositories/preferred_store_repository.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/common/ui.dart';
import 'package:ecom_user_flutter/models/ecom/product/shop_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'preferred_store_controller.dart';

class PreferredStoreCodeLookupController extends GetxController {
  final PreferredStoreRepository _repo = PreferredStoreRepository();

  final codeController = TextEditingController();
  final code = ''.obs;
  final isFindingShop = false.obs;
  final isSettingActive = false.obs;
  final foundShop = Rxn<ShopProfile>();
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    codeController.addListener(() {
      code.value = codeController.text.trim();
    });
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  bool get canFind => code.value.length == 6 && !isFindingShop.value;

  Future<void> findShopByCode() async {
    final cleanCode = codeController.text.trim();
    if (cleanCode.length != 6) {
      errorMessage.value = 'Enter a valid 6 digit store code.';
      return;
    }

    if (isFindingShop.value) return;
    isFindingShop.value = true;
    errorMessage.value = '';
    foundShop.value = null;

    try {
      final response = await _repo.findShopByCode(code: cleanCode);
      if (response is Map && response['status'] == 'success') {
        final model = ShopProfileResponse.fromJson(
          Map<String, dynamic>.from(response),
        );
        if (model.data == null) {
          errorMessage.value = 'No active store found for this code.';
          return;
        }
        foundShop.value = model.data;
        return;
      }

      errorMessage.value = _messageForFindResponse(response);
    } catch (e) {
      errorMessage.value = _messageFromException(e);
    } finally {
      isFindingShop.value = false;
    }
  }

  Future<void> setFoundShopAsActive() async {
    final shop = foundShop.value;
    final sellerId = shop?.userId;
    if (shop == null || sellerId == null) return;

    final auth = Get.find<AuthService>();
    if (auth.currentUser.value.data == null) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    if (isSettingActive.value) return;
    isSettingActive.value = true;
    errorMessage.value = '';

    try {
      final response = await _repo.setActiveSellerPreference(sellerId: sellerId);
      if (response is Map && response['status'] == 'success') {
        final activeStore = _asMap(_asMap(response['data'])?['active_store']);
        final activeSeller = _asMap(activeStore?['seller']);
        final activeShop = _asMap(activeSeller?['shop']) ?? <String, dynamic>{};
        final slug = activeShop['slug']?.toString().trim() ?? '';
        final activeSellerId = _asInt(activeStore?['seller_id']);

        if (slug.trim().isEmpty) {
          throw Exception('Active store slug missing from backend response');
        }
        if (activeSellerId == null) {
          throw Exception('Active seller id missing from backend response');
        }

        await Get.find<StoreContextService>().setActiveStore(
          slug: slug,
          id: shop.id,
          sellerId: activeSellerId,
          name: shop.displayName,
          logo: shop.logoUrl,
          banner: shop.bannerUrl,
        );

        if (Get.isRegistered<PreferredStoreController>()) {
          await Get.find<PreferredStoreController>().getPreferredStores(reset: true);
        }

        Get.showSnackbar(
          Ui.SuccessSnackBar(
            title: 'Success'.tr,
            message: response['message']?.toString() ??
                'Active preferred store updated successfully',
          ),
        );
        Get.offNamed(Routes.PREFERRED_STORES);
        return;
      }

      final message = _messageForSetActiveResponse(response);
      errorMessage.value = message;
      Get.showSnackbar(Ui.ErrorSnackBar(title: 'Error'.tr, message: message));
      _redirectIfUnauthorized(response);
    } catch (e) {
      final message = _messageFromException(e);
      errorMessage.value = message;
      Get.showSnackbar(Ui.ErrorSnackBar(title: 'Error'.tr, message: message));
    } finally {
      isSettingActive.value = false;
    }
  }

  void goToScanner() {
    Get.toNamed(Routes.QR_SCAN);
  }

  void clearCode() {
    codeController.clear();
    foundShop.value = null;
    errorMessage.value = '';
  }

  String _messageForFindResponse(dynamic response) {
    if (response is Map) {
      final message = response['message']?.toString().trim();
      if (message == 'Shop not found' || response['status'] == 'failed') {
        return 'No active store found for this code.';
      }
      if (message != null && message.isNotEmpty) return message;
    }
    return 'No active store found for this code.';
  }

  String _messageForSetActiveResponse(dynamic response) {
    if (response is Map) {
      final status = response['status']?.toString();
      final code = response['status_code']?.toString();
      final message = response['message']?.toString().trim();

      if (status == '403' || code == '403') {
        return 'Only customer accounts can select active store.';
      }
      if (message != null && message.isNotEmpty) return message;
    }
    return 'Could not set active store.';
  }

  void _redirectIfUnauthorized(dynamic response) {
    if (response is! Map) return;
    final status = response['status']?.toString();
    final code = response['status_code']?.toString();
    final message = response['message']?.toString().toLowerCase() ?? '';
    if (status == '401' ||
        code == '401' ||
        message.contains('invalid or expired api token') ||
        message.contains('unauthenticated')) {
      Get.find<AuthService>().removeCurrentUser();
      Get.offNamed(Routes.LOGIN);
    }
  }

  String _messageFromException(Object error) {
    final message = error.toString();
    if (message.contains('StatusCode: 404')) {
      return 'No active store found for this code.';
    }
    return message.replaceFirst('Exception: ', '');
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? double.tryParse(value.toString())?.toInt();
  }
}
