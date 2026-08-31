import 'package:ecom_user_flutter/app/modules/banner/controller/banner_controller.dart';
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/modules/category/controller/category_controller.dart';
import 'package:ecom_user_flutter/app/modules/order/controller/order_controller.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/modules/home/controllers/home_controller.dart';

import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    Get.lazyPut<CategoryController>(
          () => CategoryController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<OrderController>(
      () => OrderController(),
    );
    Get.lazyPut<BannerController>(
      () => BannerController(),
    );

    Get.lazyPut<CartController>(
      () => CartController(),
    );

    Get.lazyPut<PreferredStoreController>(
      () => PreferredStoreController(),
      fenix: true,
    );

    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
  }
}
