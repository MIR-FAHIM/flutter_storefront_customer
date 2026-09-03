import 'package:ecom_user_flutter/app/models/ecom/delivery/delivery_report.dart';
import 'package:ecom_user_flutter/app/models/ecom/profile_model.dart';

import 'package:ecom_user_flutter/app/repositories/auth_repositories.dart';
import 'package:ecom_user_flutter/app/repositories/delivery_rep.dart';
import 'package:ecom_user_flutter/app/modules/banner/controller/banner_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecom_user_flutter/app/modules/settings/controllers/language_controller.dart';

import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/common/ui.dart';
import 'package:ecom_user_flutter/main.dart';
import 'package:ecom_user_flutter/service/shared_pref.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final balance = '0.0'.obs;
  final phoneController = TextEditingController().obs;
  final outletNameController = TextEditingController().obs;
  final ownerController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final status = false.obs;
  final packageName = "".obs;

  final packageLoad = false.obs;
  final hideChatBox = false.obs;
  final unreadChatCount = 0.obs;

  final userID = 0.obs;
  final deliveryReport = DeliveryReportModel().obs;
  final box = GetStorage().obs;
  final contactsResult = <Contact>[].obs;
  final profileData = ProfileData().obs;

  @override
  Future<void> onInit() async {
    if (Get.find<AuthService>().currentUser.value.data != null) {
      userID.value = Get.find<AuthService>().currentUser.value.data!.user!.id!;
      getProfile();
      getUnreadChatCount();
    }

    super.onInit();
    print('HomeController.onInit');
  }

  Future<void> refreshHome() async {
    await Future.wait([
      getUnreadChatCount(),
      Get.find<BannerController>().getBanners(),
      Get.find<BannerController>().getShopDetails(),
      Get.find<ProductController>().reloadStorefrontData(),
    ]);
  }

  Future<void> getUnreadChatCount() async {
    final response = await AuthRepository().getChatUnreadCount();

    print("i am here 543");
    if (response is Map && response['status'] == 'success') {

      final data = response['data'];
      if (data is Map) {

        unreadChatCount.value =
            int.tryParse(data['total_unread_count'].toString()) ?? 0;
        print("i am here 453  ${unreadChatCount.value}");

      }
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady

    super.onReady();
  }

  getProfile() {
    AuthRepository().getProfile(userID.value.toString()).then((e) {
      print("profile data is $e");
      if (e['status'] == 'success') {
        ProfileModel model = ProfileModel.fromJson(e);
        profileData.value = model.data!;
        print("profile data name is ${profileData.value.name}");
      } else if (e['message'] == "Invalid app token") {
        Get.find<AuthService>().removeCurrentUser();

        Get.toNamed(Routes.SPLASHSCREEN);
      }
    });
  }
}
