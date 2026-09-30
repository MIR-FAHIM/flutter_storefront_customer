import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/modules/gamification/controller/gamification_controller.dart';

class GamificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GamificationController>(
      () => GamificationController(),
      fenix: true,
    );
  }
}
