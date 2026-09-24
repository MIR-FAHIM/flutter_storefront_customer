// lib/app/modules/category/controller/category_controller.dart

import 'package:ecom_user_flutter/app/models/ecom/order/order_details.dart';
import 'package:ecom_user_flutter/app/models/ecom/order/order_history_model.dart';
import 'package:ecom_user_flutter/app/repositories/order_rep.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../routes/store_navigation.dart';

class OrderController extends GetxController {
  final isLoading = false.obs;
  final orderId = 0.obs;
  final orderDetails = Rxn<OrderDetailsData>();
  final isOrderDetailsLoading = false.obs;
  final orderDetailsError = ''.obs;
  final error = ''.obs;
  final selectedAddress = ''.obs;
  final isLoadingDetail = false.obs;
  final totalAmount = 0.0.obs;
  final orderHistory = <OrderHistoryItem>[].obs;
  @override
  void onInit() {
    if (Get.find<AuthService>().currentUser.value.data != null) {
      userOrderHistoryController();
    }

    super.onInit();
  }

  Future<void> userOrderHistoryController() async {
    print('i am userOrderHistoryController');

    isLoading.value = true;
    error.value = '';

    try {
      final res = await OrderRepository().getUserOrderList();
      // Debug
      // print('Category API res = $res');

      if (res is Map && res['status'] == 'success') {
        final model =
            OrderHistoryResModel.fromJson(res as Map<String, dynamic>);
        orderHistory.assignAll(model.data?.items ?? const []);
        print('i am here3456523');
      } else {
        error.value =
            (res is Map ? (res['message']?.toString() ?? 'Failed') : 'Failed');
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrderDetails(dynamic orderId, {bool navigate = true}) async {
    final normalizedOrderId = orderId?.toString().trim() ?? '';
    if (normalizedOrderId.isEmpty) {
      orderDetailsError.value = 'Order ID not found';
      return;
    }

    if (navigate) {
      await Get.toNamed(
        storeAwarePath(
          Routes.ORDER_DETAIL,
          '/order/$normalizedOrderId',
        ),
        arguments: {'order_id': normalizedOrderId},
      );
      return;
    }

    if (isOrderDetailsLoading.value) return;

    isOrderDetailsLoading.value = true;
    orderDetailsError.value = '';
    orderDetails.value = null;

    try {
      // Change this line according to your repository method.
      final res = await OrderRepository().orderDetail(normalizedOrderId);

      if (res is Map && res['status'] == 'success') {
        final model = OrderDetailsResponse.fromJson(
          Map<String, dynamic>.from(res),
        );

        orderDetails.value = model.data;
      } else {
        orderDetailsError.value = res is Map
            ? (res['message']?.toString() ?? 'Failed to load order details')
            : 'Failed to load order details';
      }
    } catch (e) {
      orderDetailsError.value = e.toString();
    } finally {
      isOrderDetailsLoading.value = false;
    }
  }
}
