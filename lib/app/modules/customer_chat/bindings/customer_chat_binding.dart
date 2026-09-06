import 'package:ecom_user_flutter/app/modules/customer_chat/controllers/customer_chat_controller.dart';
import 'package:get/get.dart';

class CustomerChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerChatController>(
      () => CustomerChatController(),
    );
  }
}
