// lib/app/modules/home/controllers/banner_controller.dart
// Fix controller: null safe + loading + proper assignAll

import 'package:ecom_user_flutter/app/models/ecom/banner_model.dart';
import 'package:ecom_user_flutter/app/repositories/banner_rep.dart';
import 'package:ecom_user_flutter/app/repositories/preferred_store_repository.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/shop_model.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  final bannerData = <BannerData>[].obs;
  final shopDetails = Rxn<Datum>();
  final isLoading = false.obs;
  final isShopLoading = false.obs;

  StoreContextService get _storeContext => Get.find<StoreContextService>();
  int _shopRequestToken = 0;

  @override
  void onInit() {
    super.onInit();
    ever<int?>(_storeContext.activeStoreId, (_) => getShopDetails());
    getBanners();

    getShopDetails();
  }

  Future<void> getBanners() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final e = await BannerRepository().getBanner();
      if (e is Map && e['status'] == 'success') {
        final model = BannerResModel.fromJson(e as Map<String, dynamic>);
        bannerData.assignAll(model.data); // model.data is List<BannerData>
      } else {
        bannerData.clear();
      }
    } catch (_) {
      bannerData.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getShopDetails() async {

    final shopId = _storeContext.activeStoreId.value;
    final requestToken = ++_shopRequestToken;
    print("shop id is 432 $shopId");
    if (shopId == null) {
      shopDetails.value = null;
      return;
    }
    isShopLoading.value = true;
    try {
      final response = await PreferredStoreRepository().getShopDetails(
        shopId: shopId,
      );

      if (response is Map && response['status'] == 'success') {
        final data = response['data'];
        shopDetails.value = data is Map
            ? Datum.fromJson(Map<String, dynamic>.from(data))
            : null;
      } else {
        shopDetails.value = null;
      }
    } catch (_) {
      if (requestToken == _shopRequestToken) shopDetails.value = null;
    } finally {
      if (requestToken == _shopRequestToken) isShopLoading.value = false;
    }
  }
}
