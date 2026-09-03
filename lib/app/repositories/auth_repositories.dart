import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';

import 'package:ecom_user_flutter/app/services/auth_service.dart';

class AuthRepository {
  final userdata = GetStorage();
  Map<String, String> get header => {
        'Authorization':
            'Bearer ${Get.find<AuthService>().currentUser.value.data!.token}',
      };

  ///User login api call
  userLogin(Map data) async {
    APIManager _manager = APIManager();
    final response = await _manager.loginAPICall(ApiClient.login, data);

    print('user login: ${response}');

    return response;
  }

  signUp(Map data) async {
    APIManager _manager = APIManager();
    final response = await _manager.loginAPICall(ApiClient.createUser, data);

    print('user createUser: ${response}');

    return response;
  }

  getProfile(String userID) async {
    APIManager _manager = APIManager();
    final response =
        await _manager.getWithHeader(ApiClient.userDetails + userID, header);

    print('user profile: ${response}');

    return response;
  }

  Future<dynamic> getChatUnreadCount() async {
    final response = await APIManager().getWithHeader(
      ApiClient.chatUnreadCount,
      {
        ...header,
        'Accept': 'application/json',
      },
    );

    return response;
  }
}
