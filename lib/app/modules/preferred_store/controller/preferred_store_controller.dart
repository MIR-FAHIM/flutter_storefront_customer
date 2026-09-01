import 'package:ecom_user_flutter/models/ecom/product/preferred_store_model.dart';
import 'package:ecom_user_flutter/app/repositories/preferred_store_repository.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/common/ui.dart';
import 'package:get/get.dart';

class PreferredStoreController extends GetxController {
  final PreferredStoreRepository _repo = PreferredStoreRepository();

  final preferredStores = <PreferredStoreItem>[].obs;
  final preferredSellerIds = <int>{}.obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final isRemoving = false.obs;
  final isAdding = false.obs;
  final activatingSellerIds = <int>{}.obs;
  final error = ''.obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final total = 0.obs;
  final hasMore = true.obs;

  int _requestToken = 0;

  @override
  void onInit() {
    super.onInit();
    if (_isLoggedIn) {
      getPreferredStores(reset: true);
    }
  }

  bool get _isLoggedIn {
    return Get.find<AuthService>().currentUser.value.data != null;
  }

  int? get _customerId {
    return Get.find<AuthService>().currentUser.value.data?.user?.id;
  }

  Future<void> getPreferredStores({bool reset = false}) async {
    if (!_isLoggedIn) {
      error.value = 'Please login to view preferred stores.';
      Get.toNamed(Routes.LOGIN);
      return;
    }

    if (!reset && !hasMore.value) return;
    if (!reset && (isLoading.value || isMoreLoading.value)) return;

    final requestToken = ++_requestToken;

    if (reset) {
      currentPage.value = 1;
      lastPage.value = 1;
      total.value = 0;
      hasMore.value = true;
      preferredStores.clear();
      preferredSellerIds.clear();
      isLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

    error.value = '';

    try {
      final pageToLoad = reset ? 1 : currentPage.value;
      final response = await _repo.getPreferredStores(
        page: pageToLoad,
        perPage: 20,
      );

      if (requestToken != _requestToken) return;

      if (response is Map && response['status'] == 'success') {
        final model = PreferredStoreResponse.fromJson(
          Map<String, dynamic>.from(response),
        );

        final page = model.data;
        if (reset) {
          preferredStores.assignAll(page.items);
        } else {
          preferredStores.addAll(page.items);
        }

        _syncPreferredSellerIds();
        currentPage.value = page.currentPage < page.lastPage
            ? page.currentPage + 1
            : page.currentPage;
        lastPage.value = page.lastPage;
        total.value = page.total;
        hasMore.value = page.currentPage < page.lastPage;
        return;
      }

      preferredStores.clear();
      _syncPreferredSellerIds();
      error.value = _messageForResponse(response);
      _redirectIfUnauthorized(response);
    } catch (e) {
      if (requestToken == _requestToken) {
        preferredStores.clear();
        _syncPreferredSellerIds();
        error.value = e.toString();
      }
    } finally {
      if (requestToken == _requestToken) {
        isLoading.value = false;
        isMoreLoading.value = false;
      }
    }
  }

  Future<void> refreshPreferredStores() async {
    await getPreferredStores(reset: true);
  }

  bool isActivating(PreferredStoreItem item) {
    final sellerId = item.resolvedSellerId;
    return sellerId != null && activatingSellerIds.contains(sellerId);
  }

  bool isActive(PreferredStoreItem item) =>
      item.status.trim().toLowerCase() == 'active';

  Future<void> setActiveStore(
    PreferredStoreItem item, {
    bool goToStoreHome = false,
  }) async {
    if (!_isLoggedIn) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    final sellerId = item.resolvedSellerId;
    final slug = item.slug.trim();
    if (sellerId == null || slug.isEmpty || isActive(item)) return;
    if (activatingSellerIds.contains(sellerId)) return;

    activatingSellerIds.add(sellerId);
    activatingSellerIds.refresh();

    try {
      final response = await _repo.setActiveSellerPreference(
        sellerId: sellerId,
      );

      if (response is Map && response['status'] == 'success') {
        for (final store in preferredStores) {
          store.status = store.resolvedSellerId == sellerId
              ? 'active'
              : 'inactive';
        }
        preferredStores.refresh();

        await Get.find<StoreContextService>().setActiveStore(
          slug: slug,
          id: item.shop?.id,
          sellerId: sellerId,
          name: item.displayName,
          logo: item.logoUrl,
          banner: item.bannerUrl,
        );

        await getPreferredStores(reset: true);
        Get.showSnackbar(
          Ui.SuccessSnackBar(
            title: 'Success'.tr,
            message: response['message']?.toString() ??
                'Active store changed successfully',
          ),
        );
        if (goToStoreHome) {
          Get.offAllNamed('/store/$slug');
        }
        return;
      }

      final message = _messageForResponse(response);
      Get.showSnackbar(Ui.ErrorSnackBar(title: 'Error'.tr, message: message));
      _redirectIfUnauthorized(response);
    } catch (e) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(title: 'Error'.tr, message: e.toString()),
      );
    } finally {
      activatingSellerIds.remove(sellerId);
      activatingSellerIds.refresh();
    }
  }

  Future<void> loadMorePreferredStores() async {
    await getPreferredStores(reset: false);
  }

  Future<bool> addSellerPreference({required dynamic sellerId}) async {
    if (!_isLoggedIn) {
      Get.toNamed(Routes.LOGIN);
      return false;
    }

    final parsedSellerId = _asInt(sellerId);
    if (parsedSellerId != null && preferredSellerIds.contains(parsedSellerId)) {
      return true;
    }

    if (isAdding.value) return false;
    isAdding.value = true;

    try {
      final response = await _repo.addSellerPreference(sellerId: sellerId);

      if (response is Map && response['status'] == 'success') {
        if (parsedSellerId != null) {
          preferredSellerIds.add(parsedSellerId);
          preferredSellerIds.refresh();
        }
        await getPreferredStores(reset: true);
        Get.showSnackbar(
          Ui.SuccessSnackBar(
            message:
                response['message']?.toString() ?? 'Store added to preference',
            title: 'Success'.tr,
          ),
        );
        return true;
      }

      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: _messageForResponse(response),
          title: 'Error'.tr,
        ),
      );
      _redirectIfUnauthorized(response);
      return false;
    } catch (e) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: e.toString(),
          title: 'Error'.tr,
        ),
      );
      return false;
    } finally {
      isAdding.value = false;
    }
  }

  Future<void> removePreference(PreferredStoreItem item) async {
    if (isRemoving.value) return;

    final customerId = _customerId;
    final sellerId = item.resolvedSellerId;

    if (customerId == null || sellerId == null) {
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: 'Preference owner or seller not found',
          title: 'Error'.tr,
        ),
      );
      return;
    }

    isRemoving.value = true;
    error.value = '';

    try {
      final response = await _repo.removeSellerPreference(
        customerUserId: customerId,
        sellerId: sellerId,
      );

      if (response is Map && response['status'] == 'success') {
        preferredStores.removeWhere(
          (store) =>
              store.id == item.id || store.resolvedSellerId == item.resolvedSellerId,
        );
        preferredSellerIds.remove(sellerId);
        preferredStores.refresh();
        preferredSellerIds.refresh();
        total.value = preferredStores.length;

        Get.showSnackbar(
          Ui.SuccessSnackBar(
            message: 'Store removed from preferences',
            title: 'Success'.tr,
          ),
        );
        return;
      }

      error.value = _messageForResponse(response);
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: error.value,
          title: 'Error'.tr,
        ),
      );
      _redirectIfUnauthorized(response);
    } catch (e) {
      error.value = e.toString();
      Get.showSnackbar(
        Ui.ErrorSnackBar(
          message: error.value,
          title: 'Error'.tr,
        ),
      );
    } finally {
      isRemoving.value = false;
    }
  }

  bool isPreferredSeller(dynamic sellerId) {
    final id = _asInt(sellerId);
    return id != null && preferredSellerIds.contains(id);
  }

  void _syncPreferredSellerIds() {
    preferredSellerIds
      ..clear()
      ..addAll(
        preferredStores
            .map((item) => item.resolvedSellerId)
            .whereType<int>(),
      );
    preferredSellerIds.refresh();
  }

  String _messageForResponse(dynamic response) {
    if (response is Map) {
      final statusCode = response['status_code']?.toString();
      final message = response['message']?.toString();
      final status = response['status']?.toString();

      if (statusCode == '403' || status == '403') {
        return 'You do not have permission.';
      }

      if (message != null && message.trim().isNotEmpty) return message;
    }

    return 'Failed to load preferred stores';
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

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ??
        double.tryParse(value.toString())?.toInt();
  }
}
