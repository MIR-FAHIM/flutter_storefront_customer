import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_controller.dart';
import 'package:get/get.dart';

class PreferredStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferredStoreController>(
      () => PreferredStoreController(),
      fenix: true,
    );
  }
}
