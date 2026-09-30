import 'package:get/get.dart';
import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';

class GamificationRepository {
  final APIManager _manager = APIManager();

  String? get _token {
    if (Get.isRegistered<AuthService>()) {
      return Get.find<AuthService>().currentUser.value.data?.token;
    }
    return null;
  }

  Map<String, String> get _authHeader {
    final token = _token;
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    };
  }

  Future<dynamic> getShopChallenge(String storeSlug) {
    final url = '${ApiClient.shopChallenge}$storeSlug/challenge';
    return _manager.getWithHeader(url, _authHeader);
  }

  Future<dynamic> getCustomerStoreRelation(int storeId) {
    final url = '${ApiClient.customerStoreRelation}$storeId';
    return _manager.getWithHeader(url, _authHeader);
  }

  Future<dynamic> joinChallenge(int challengeId, int userId) {
    final url = '${ApiClient.joinChallenge}$challengeId/join';
    return _manager.postAPICallWithHeader(
      url,
      {'user_id': userId.toString()},
      _authHeader,
    );
  }

  Future<dynamic> getMyChallenges(int userId) {
    final url = Uri.parse(ApiClient.myChallenges).replace(
      queryParameters: {'user_id': userId.toString()},
    );
    return _manager.getWithHeader(url.toString(), _authHeader);
  }

  Future<dynamic> claimReward(int claimId) {
    final url = '${ApiClient.claimReward}$claimId/claim';
    return _manager.postAPICallWithHeader(url, {}, _authHeader);
  }
}
