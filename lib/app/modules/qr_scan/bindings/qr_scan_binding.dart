import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_controller.dart';
import '../controllers/qr_scan_controller.dart';
import '../repositories/qr_scan_repository.dart';

class QrScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrScanRepository>(() => QrScanRepository());
    if (!Get.isRegistered<PreferredStoreController>()) {
      Get.lazyPut<PreferredStoreController>(
        () => PreferredStoreController(),
        fenix: true,
      );
    }
    Get.lazyPut<QrScanController>(
      () => QrScanController(repository: Get.find<QrScanRepository>()),
    );
  }
}
