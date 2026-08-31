// lib/app/modules/category/controller/category_controller.dart

import 'package:ecom_user_flutter/app/models/ecom/product/category_child_model.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/category_model.dart';

import 'package:ecom_user_flutter/app/repositories/product_rep.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final isLoading = false.obs;
  final categories = <CategoryItem>[].obs;
  final categoryChilds = <DatumCatChild>[].obs;
  final error = ''.obs;
  Worker? _storeSlugWorker;
  int _categoryRequestToken = 0;

  StoreContextService get _storeContext => Get.find<StoreContextService>();

  @override
  void onInit() {
    super.onInit();
    _storeSlugWorker = ever<String>(
      _storeContext.activeStoreSlug,
      (_) => getCategories(forceRefresh: true),
    );
    if (!_storeContext.hasActiveStore) return;
    getCategories();
  }

  @override
  void onClose() {
    _storeSlugWorker?.dispose();
    super.onClose();
  }

  Future<void> getCategories({bool forceRefresh = false}) async {
    if (isLoading.value && !forceRefresh) return;
    if (!_storeContext.hasActiveStore) {
      categories.clear();
      return;
    }

    isLoading.value = true;
    error.value = '';
    final requestToken = ++_categoryRequestToken;

    try {
      final res = await ProductRepository().getCategory(
        storeSlug: _storeContext.storeSlugOrNull,
      );
      if (requestToken != _categoryRequestToken) return;
      // Debug
      // print('Category API res = $res');

      if (res is Map && res['status'] == 'success') {
        final model = CategoryResModel.fromJson(res as Map<String, dynamic>);
        categories.assignAll(model.data?.data ?? <CategoryItem>[]);
      } else {
        categories.clear();
        error.value = (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      if (requestToken == _categoryRequestToken) {
        categories.clear();
        error.value = e.toString();
      }
    } finally {
      if (requestToken == _categoryRequestToken) {
        isLoading.value = false;
      }
    }
  }

  Future<void> getCategoryChildController(id) async {
    print("i am called 568");

    error.value = '';

    try {
      final res = await ProductRepository().getCategoryChild(
        id,
        storeSlug: _storeContext.storeSlugOrNull,
      );
      // Debug
       print('Category API res 56866= $res');

      if (res is Map && res['status'] == 'success') {

        final model = CategoryChildModel.fromJson(res as Map<String, dynamic>);
        categoryChilds.assignAll(model.data ?? <DatumCatChild>[]);
        print('Category API res 5566= ${categoryChilds.length}');
      } else {
        categoryChilds.clear();
        error.value = (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      categoryChilds.clear();
      error.value = e.toString();
    } finally {
      //isLoading.value = false;
    }
  }
}
