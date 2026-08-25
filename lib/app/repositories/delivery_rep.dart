import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';

import 'package:ecom_user_flutter/app/services/auth_service.dart';

class DeliveryRepository {
  final userdata = GetStorage();




 addAddress(Map data) async {
   Map<String, String> header = {
     'Authorization' : "Bearer ${Get.find<AuthService>().currentUser.value.data!.token}",
   };

    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader(ApiClient.addAddress, data,header);

    print('add address: ${response}');

    return response;
  }

  assignedDelivery(String userID) async {
    APIManager _manager = APIManager();
    final response =
        await _manager.getWithHeader(ApiClient.assignedDelivery + userID, {});

    print('assignedDelivery 34345: ${response}');

    return response;
  }

  deliveredDelivery(String userID) async {
    APIManager _manager = APIManager();
    final response =
        await _manager.getWithHeader(ApiClient.deliveredDelivery + userID, {});

    print('deliveredDelivery 453: ${response}');

    return response;
  }

  completedAllDelivery(String userID) async {
    APIManager _manager = APIManager();
    final response =
        await _manager.getWithHeader(ApiClient.completedDelivery + userID, {});

    print('completedAllDelivery 4332: ${response}');

    return response;
  }

  reportDelivery(String userID) async {
    APIManager _manager = APIManager();
    final response =
        await _manager.getWithHeader(ApiClient.reportDelivery + userID, {});

    print('reportDelivery 4334: ${response}');

    return response;
  }
}
