import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:get/get.dart';

String storeAwarePath(String fallbackRoute, String storeSuffix) {
  final slug = Get.find<StoreContextService>().storeSlugOrNull;
  if (slug == null || slug.isEmpty) return fallbackRoute;
  return '/store/$slug$storeSuffix';
}

void offAllToStoreHomeOrRoot() {
  Get.offAllNamed(storeAwarePath(Routes.ROOT, ''));
}

void offToStoreHomeOrRoot() {
  Get.offNamed(storeAwarePath(Routes.ROOT, ''));
}
