import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_controller.dart';
import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import '../repositories/qr_scan_repository.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanController extends GetxController {
  QrScanController({required this.repository});

  final QrScanRepository repository;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final scannedData = ''.obs;
  final mobileScannerController = MobileScannerController();
  bool _isRestartingScanner = false;

  @override
  void onClose() {
    mobileScannerController.dispose();
    super.onClose();
  }

  Future<void> processQrCode(String qrData) async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      errorMessage.value = '';
      scannedData.value = qrData;

      final payload = await repository.resolveQrCode(qrData);
      final preferredStores = Get.find<PreferredStoreController>();
      await preferredStores.getPreferredStores(reset: true);

      var store = preferredStores.preferredStores.firstWhereOrNull(
        (item) =>
            item.slug == payload.slug || item.resolvedSellerId == payload.sellerId,
      );

      if (store == null && payload.sellerId == null) {
        throw Exception(
          'This QR code does not contain a seller id. Please use a store QR code.',
        );
      }

      if (store == null) {
        final added = await preferredStores.addSellerPreference(
          sellerId: payload.sellerId,
        );
        if (!added) throw Exception('Could not add store to preferences');
        store = preferredStores.preferredStores.firstWhereOrNull(
          (item) =>
              item.slug == payload.slug || item.resolvedSellerId == payload.sellerId,
        );
      }

      if (store == null) throw Exception('Store was not returned by the backend');
      if (!preferredStores.isActive(store)) {
        await preferredStores.setActiveStore(store);
      } else {
        await Get.find<StoreContextService>().setActiveStore(
          slug: store.slug,
          id: store.shop?.id,
          sellerId: store.resolvedSellerId,
          name: store.displayName,
          logo: store.logoUrl,
          banner: store.bannerUrl,
        );
      }

      // Show success message
      Get.snackbar(
        'Success',
        'Store loaded successfully',
        duration: const Duration(seconds: 2),
      );

      // Navigate to the selected storefront after a short delay.
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed('/store/${store!.slug}');
      });
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load store: ${e.toString()}',
        duration: const Duration(seconds: 3),
        isDismissible: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> restartScanner() async {
    if (_isRestartingScanner) return;
    _isRestartingScanner = true;
    try {
      try {
        await mobileScannerController.stop();
      } catch (_) {
        // The camera may already be stopped after a scanner error.
      }
      await Future<void>.delayed(const Duration(milliseconds: 150));
      try {
        await mobileScannerController.start();
      } catch (e) {
        errorMessage.value = e.toString();
      }
    } finally {
      _isRestartingScanner = false;
    }
  }
}
