import 'package:ecom_user_flutter/app/models/ecom/product/brand_model.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/shop_model.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_controller.dart';
import 'package:ecom_user_flutter/app/repositories/product_rep.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  final shopList = <Datum>[].obs;
  final brandList = <BrandItem>[].obs;

  final isLoadingShops = false.obs;
  final isLoadingBrands = false.obs;
  final isAddingPreference = false.obs;

  final error = ''.obs;
  StoreContextService get _storeContext => Get.find<StoreContextService>();
  PreferredStoreController get _preferredStoreController {
    if (!Get.isRegistered<PreferredStoreController>()) {
      Get.lazyPut<PreferredStoreController>(
        () => PreferredStoreController(),
        fenix: true,
      );
    }
    return Get.find<PreferredStoreController>();
  }

  @override
  void onInit() {
    super.onInit();

    getShops();
    getBrands();
    if (Get.find<AuthService>().currentUser.value.data != null) {
      _preferredStoreController.getPreferredStores(reset: true);
    }
  }

  Future<void> getShops() async {
    try {
      isLoadingShops.value = true;
      error.value = '';
  Map<String, dynamic> param = {
    'status' : 'active'
  };
      final response = await ProductRepository().getShop(params: param );

      if (response is Map<String, dynamic>) {
        final model = ShopListResModel.fromJson(response);

        if (model.status == "success") {
          shopList.assignAll(model.data?.data ?? []);
        } else {
          error.value = model.message ?? 'Failed to load shops';
          shopList.clear();
        }
      } else {
        error.value = 'Invalid response';
        shopList.clear();
      }
    } catch (e) {
      error.value = e.toString();
      shopList.clear();
    } finally {
      isLoadingShops.value = false;
    }
  }

  Future<void> getBrands() async {
    try {
      isLoadingBrands.value = true;

      final response = await ProductRepository().getBrands();

      if (response is Map<String, dynamic>) {
        final model = BrandResModel.fromJson(response);

        if (model.status == "success") {
          brandList.assignAll(model.data?.items ?? []);
        } else {
          brandList.clear();
        }
      } else {
        brandList.clear();
      }
    } catch (e) {
      brandList.clear();
    } finally {
      isLoadingBrands.value = false;
    }
  }

  Future<void> openStore(Datum store) async {
    final slug = (store.slug ?? '').trim();
    if (slug.isEmpty) {
      Get.snackbar('Store', 'Store slug not found');
      return;
    }

    await _storeContext.setActiveStore(
      slug: slug,
      id: store.id,
      sellerId: store.userId ?? store.user?.id,
      name: store.shopName ?? store.name,
      logo: store.logo?.url ?? store.logo?.fileName,
      banner: store.banner?.url ?? store.banner?.fileName,
    );

    Get.offAllNamed('/store/$slug');
  }

  Future<void> addStorePreference(Datum store) async {
    final sellerId = store.userId ?? store.user?.id;
    if (sellerId == null) {
      Get.snackbar('Store', 'Seller id not found for this store');
      return;
    }

    if (Get.find<AuthService>().currentUser.value.data == null) {
      final slug = (store.slug ?? '').trim();
      await _storeContext.saveLoginRedirect(
        route: slug.isEmpty ? Routes.SHOP_LIST : '/store/$slug',
        arguments: {
          'store_slug': slug,
        },
      );
      Get.toNamed(Routes.LOGIN);
      return;
    }

    if (isAddingPreference.value) return;
    isAddingPreference.value = true;

    try {
      await _preferredStoreController.addSellerPreference(sellerId: sellerId);
    } catch (e) {
      Get.snackbar('Store Preference', e.toString());
    } finally {
      isAddingPreference.value = false;
    }
  }

  bool isStorePreferred(Datum store) {
    final sellerId = store.userId ?? store.user?.id;
    return _preferredStoreController.isPreferredSeller(sellerId);
  }
}
