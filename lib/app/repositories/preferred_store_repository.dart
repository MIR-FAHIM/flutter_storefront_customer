import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:get/get.dart';

class PreferredStoreRepository {
  Map<String, String> get header => {
        'Authorization':
            'Bearer ${Get.find<AuthService>().currentUser.value.data!.token}',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      };

  Future<dynamic> getPreferredStores({
    int? page,
    int? perPage,
  }) async {
    final manager = APIManager();
    final params = <String, dynamic>{};

    if (page != null) params['page'] = page;
    params['per_page'] = perPage ?? 20;

    final uri = Uri.parse(ApiClient.preferredStores).replace(
      queryParameters: params.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final response = await manager.getWithHeader(uri.toString(), header);
    print('getPreferredStores 544: $response');
    return response;
  }

  Future<dynamic> findShopByCode({required String code}) async {
    final manager = APIManager();
    final response = await manager.get('${ApiClient.findShopByCode}$code');
    print('findShopByCode 544: $response');
    return response;
  }

  Future<dynamic> setActiveSellerPreference({required int sellerId}) async {
    final manager = APIManager();
    return manager.postAPICallWithEncoded(
      ApiClient.setActiveSellerPreference,
      {'seller_id': sellerId},
      {
        ...header,
        'Content-Type': 'application/json',
      },
    );
  }

  Future<dynamic> addSellerPreference({required dynamic sellerId}) async {
    final manager = APIManager();
    final response = await manager.postAPICallWithHeader(
      ApiClient.addSellerPreference,
      {
        'seller_id': sellerId.toString(),
      },
      header,
    );

    print('addSellerPreference 544: $response');
    return response;
  }

  Future<dynamic> removeSellerPreference({
    required dynamic customerUserId,
    required dynamic sellerId,
  }) async {
    final manager = APIManager();
    final response = await manager.deleteAPICallWithHeader(
      ApiClient.removeSellerPreference,
      {
        'customer_user_id': customerUserId.toString(),
        'seller_id': sellerId.toString(),
      },
      header,
    );

    print('removeSellerPreference 544: $response');
    return response;
  }
}
