
import 'package:ecom_user_flutter/app/modules/cart/view/cart_view.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/view/preferred_store_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/models/ecom/notification/popup_image_notification.dart';
import 'package:ecom_user_flutter/app/modules/home/views/home_view.dart';
import 'package:new_version_plus/new_version_plus.dart';

import '../../order/view/order_view.dart';


class RootController extends GetxController {
  //TODO: Implement RootController
  final currentIndex = 0.obs;
  final notificationType = ''.obs;
  final popNoti = true.obs;
  final imagePopUrl = "".obs;
  final imageUrlPop = "".obs;

  final imageNotificationPopList = <NotiDatum>[].obs;
  @override
  void onInit() {
    super.onInit();
    advancedStatusCheck();

    //

  }

  @override
  void onReady() {
    super.onReady();


  }

  @override
  void onClose() {}

  List<Widget> pages = [
    HomeView(),
    OrderHistoryPage(),
    CartView(),
    //MyAttendanceReportPage(),

    PreferredStoreScreen(),

  ];

  Widget get currentPage => pages[currentIndex.value];
  advancedStatusCheck() async {
    print("hle broooooo");
    final newVersion = NewVersionPlus(
      androidId: 'com.myzoo.customer',
    );
    var status = await newVersion.getVersionStatus();
    print("version status ${status!.appStoreLink}");
    if (status.canUpdate == true) {
      print("update av");
      newVersion.showUpdateDialog(
        // launchMode: LaunchMode.externalApplication,
        context: Get.context!,
        versionStatus: status,
        dialogTitle: 'Update Available!',
        dialogText: 'Upgrade  ${status.localVersion} to ${status.storeVersion}',
      );
    }
  }

}
