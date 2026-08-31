import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';

class OrderRepository {
  final userdata = GetStorage();

  Map<String, String> get header => {
        'Authorization':
            'Bearer ${Get.find<AuthService>().currentUser.value.data!.token}',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };

  String? get _storeSlug => Get.find<StoreContextService>().storeSlugOrNull;

  /// User login api call
  userLogin(String phoneNumber, String pass, String fcm) async {
    Map _loginData = {
      'email': phoneNumber,
      'password': pass,
      'fcm_token': fcm,
    };

    APIManager _manager = APIManager();
    final response = await _manager.loginAPICall(ApiClient.login, _loginData);

    print('user login: $response');

    return response;
  }

  orderDetail(String orderId) async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(
      ApiClient.orderDetail + orderId,
      header,
    );

    print('orderDetail 34345: $response');

    return response;
  }

  changeOrderStatus(String orderId, String status) async {
    APIManager _manager = APIManager();
    final response = await _manager.patchWithHeader(
      ApiClient.changeOrderStatus + orderId + '?status=$status',
      header,
    );

    print('changeOrderStatus 2323: $response');

    return response;
  }

  getCart() async {
    APIManager _manager = APIManager();
    final params = <String, dynamic>{};
    final slug = _storeSlug;
    if (slug != null && slug.isNotEmpty) params['store_slug'] = slug;
    final uri = Uri.parse(
      ApiClient.activeCart +
          Get.find<AuthService>().currentUser.value.data!.user!.id.toString(),
    ).replace(
      queryParameters: params.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    final response = await _manager.getWithHeader(
      uri.toString(),
      header,
    );

    print('getCart 3434: $response');

    return response;
  }

  getUserAddress() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(
      ApiClient.userAddresses +
          Get.find<AuthService>().currentUser.value.data!.user!.id.toString(),
      header,
    );

    print('getUserAddress 3434: $response');

    return response;
  }

  getOrderHistory() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(
      ApiClient.completedOrdersByUser +
          Get.find<AuthService>().currentUser.value.data!.user!.id.toString(),
      header,
    );

    print('getOrderHistory 32: $response');

    return response;
  }

  getUserOrderList() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(
      ApiClient.userOrders +
          Get.find<AuthService>().currentUser.value.data!.user!.id.toString(),
      header,
    );

    print('getUserOrderList 32: $response');

    return response;
  }

  checkout(data) async {
    final slug = _storeSlug;
    if (slug != null && slug.isNotEmpty && data is Map) {
      data['store_slug'] = slug;
    }

    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader(
      ApiClient.checkout,
      data,
      header,
    );

    print('checkout 45346: $response');

    return response;
  }

  initiateAamarPayPayment(data) async {
    final slug = _storeSlug;
    if (slug != null && slug.isNotEmpty && data is Map) {
      data['store_slug'] = slug;
    }

    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader(
      ApiClient.initiateAamarPayPayment,
      data,
      header,
    );

    print('initiateAamarPayPayment 45347: $response');

    return response;
  }

  updateCartItemQuantity({itemId, qty}) async {
    APIManager _manager = APIManager();
    final response = await _manager.putWithHeader(
      '${ApiClient.updateCartItem}$itemId?qty=${qty.toString()}',
      header,
    );

    print('updateCartItemQuantity 2334: $response');

    return response;
  }

  removeCartItem({itemId}) async {
    APIManager _manager = APIManager();
    final response = await _manager.deleteWithHeader(
      ApiClient.deleteCartItem + itemId,
      header,
    );

    print('removeCartItem 2334: $response');

    return response;
  }

  deleteUserAddress(id) async {
    APIManager _manager = APIManager();
    final response = await _manager.deleteWithHeader(
      ApiClient.deleteAddress + id,
      header,
    );

    print('deleteUserAddress 2334: $response');

    return response;
  }
}
