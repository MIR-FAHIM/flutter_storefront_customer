import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';

class BakiRepository {
  String? get _token {
    if (Get.isRegistered<AuthService>()) {
      return Get.find<AuthService>().currentUser.value.data?.token;
    }
    return null;
  }

  Map<String, String> get _authHeader {
    final token = _token;
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }

  Future<dynamic> getCustomerBakiLedger(int storeId, int customerId, int page) async {
    APIManager manager = APIManager();
    final url = '${ApiClient.customerBakiLedger}$storeId/baki/customer/$customerId?page=$page';
    final response = await manager.getWithHeader(url, _authHeader);
    return response;
  }
}
