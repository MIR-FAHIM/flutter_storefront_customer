import 'package:ecom_user_flutter/app/app_info.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_user_flutter/common/ui.dart';
import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  final _size = Get.size;
  @override
  Widget build(BuildContext context) {
    Get.find<SplashscreenController>();
    return Scaffold(
      backgroundColor: AppColors.discountBlue,
      body: Container(
        height: _size.height,
        width: _size.width,
        child: Stack(
          children: [

            Center(
              child: Image(
                color: AppColors.offerYellow,
                height: 200,
                width: 200,
                image: AssetImage(
                  'assets/logo/mz_full_logo.png',
                ),
              ),
            ),
            Positioned(
              bottom: 36,
              right: 0,
              left: 0,
              child: Ui.customLoaderSplash(),
            ),
            Positioned(
              bottom: 10,
              right: 0,
              left: 0,
              child: Text(
                AppInfo.versionLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
