import 'dart:async';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecom_user_flutter/app/models/ecom/notification/popup_image_notification.dart';

import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/main.dart';
import 'package:ecom_user_flutter/service/shared_pref.dart';


class SplashscreenController extends GetxController {
  //TODO: Implement SplashscreenController

  final count = 0.obs;
  final imageUrlPop = "".obs;
  final imageNotificationPopList = <NotiDatum>[].obs;
  @override
  Future<void> onInit() async {


    Timer(const Duration(seconds: 3), () {
      final slug = Get.find<StoreContextService>().storeSlugOrNull;
      Get.offAllNamed(slug == null ? Routes.ROOT : '/store/$slug');
     //  if(Get.find<AuthService>().currentUser.value.data != null){
     //    Get.offAllNamed(Routes.ROOT,);
     //  }else{
     //    Get.offAllNamed(Routes.LOGIN,);
     //  }




    });

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

}
