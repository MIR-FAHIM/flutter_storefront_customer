import 'package:get/get.dart';
import '../controller/baki_controller.dart';

class BakiBinding extends Bindings {
  @override
  void dependencies() {
    final int shopId = Get.arguments?['shop_id'] ?? 0;
    Get.lazyPut<BakiController>(() => BakiController(shopId: shopId));
  }
}
