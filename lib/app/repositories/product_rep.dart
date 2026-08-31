import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';

import 'package:ecom_user_flutter/app/services/auth_service.dart';

class ProductRepository {
  final userdata = GetStorage();

  getCategory({String? storeSlug}) async {
    APIManager _manager = APIManager();
    final slug = storeSlug?.trim();
    final response = slug != null && slug.isNotEmpty
        ? await _manager.getWithHeader(
            '${ApiClient.publicStoreCategories}$slug/categories',
            {},
          )
        : await _manager.getWithHeader(ApiClient.getCategory, {});

    print('getCategory 3453: ${response}');

    return response;
  }

  getCategoryChild(id, {String? storeSlug}) async {
    print('getCategoryChild 33333');
    APIManager _manager = APIManager();
    final params = <String, dynamic>{};
    final slug = storeSlug?.trim();
    if (slug != null && slug.isNotEmpty) params['store_slug'] = slug;
    final uri = Uri.parse(ApiClient.categoryChildren + id.toString()).replace(
      queryParameters: params.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    final response = await _manager.getWithHeader(uri.toString(), {});

    print('getCategoryChild 44444: ${response}');

    return response;
  }
  getShop({Map<String, dynamic>? params}) async {
    APIManager _manager = APIManager();

    final uri = Uri.parse(ApiClient.listShops).replace(
      queryParameters: params?.map(
            (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final response = await _manager.getWithHeader(uri.toString(), {});

    print('getShop 3453: $response');

    return response;
  }
getBrands() async {
    APIManager _manager = APIManager();
    final response = await _manager.getWithHeader(ApiClient.listBrands, {});

    print('getBrands 3453: ${response}');

    return response;
  }

  addToCart(data) async {
    Map<String, String> header = {
      'Authorization' : "Bearer ${Get.find<AuthService>().currentUser.value.data!.token}",
    };
    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader(
      ApiClient.addToCart,
      data,
        header
    );

    print('addToCart 544: ${response}');

    return response;
  }

  addSellerPreference({required dynamic sellerId}) async {
    Map<String, String> header = {
      'Authorization':
          "Bearer ${Get.find<AuthService>().currentUser.value.data!.token}",
      'Accept': 'application/json',
    };
    APIManager _manager = APIManager();
    final response = await _manager.postAPICallWithHeader(
      ApiClient.addSellerPreference,
      {
        'seller_id': sellerId.toString(),
      },
      header,
    );

    print('addSellerPreference 544: $response');

    return response;
  }

  Future<dynamic> getFeaturedProducts({
    int? page,
    int? perPage,
    int? shopId,
    int? categoryId,
    int? subCategoryId,
    int? brandId,
    String? status,
    int? isActive, // 1 or 0
    String? search,
    String? storeSlug,
  })
  async {
    final APIManager manager = APIManager();

    final Map<String, dynamic> params = {};

    if (page != null) params['page'] = page;
    if (perPage != null) params['per_page'] = perPage;

    if (shopId != null) params['shop_id'] = shopId;
    if (categoryId != null) params['category_id'] = categoryId;
    if (subCategoryId != null) params['sub_category_id'] = subCategoryId;
    if (brandId != null) params['brand_id'] = brandId;

    if (status != null && status.trim().isNotEmpty)
      params['status'] = status.trim();
    if (isActive != null) params['is_active'] = isActive;

    if (search != null && search.trim().isNotEmpty)
      params['search'] = search.trim();
    if (storeSlug != null && storeSlug.trim().isNotEmpty)
      params['store_slug'] = storeSlug.trim();

    final response = await manager.getWithHeaderAndParam(
      ApiClient.featuredProduct,
      params: params,
    );

    // print('getFilterProducts: $response');
    return response;
  }

  Future<dynamic> getTodayDealProducts({
    int? page,
    int? perPage,
    int? shopId,
    int? categoryId,
    int? subCategoryId,
    int? brandId,
    String? status,
    int? isActive, // 1 or 0
    String? search,
    String? storeSlug,
  })
  async {
    final APIManager manager = APIManager();

    final Map<String, dynamic> params = {};

    if (page != null) params['page'] = page;
    if (perPage != null) params['per_page'] = perPage;

    if (shopId != null) params['shop_id'] = shopId;
    if (categoryId != null) params['category_id'] = categoryId;
    if (subCategoryId != null) params['sub_category_id'] = subCategoryId;
    if (brandId != null) params['brand_id'] = brandId;

    if (status != null && status.trim().isNotEmpty)
      params['status'] = status.trim();
    if (isActive != null) params['is_active'] = isActive;

    if (search != null && search.trim().isNotEmpty)
      params['search'] = search.trim();
    if (storeSlug != null && storeSlug.trim().isNotEmpty)
      params['store_slug'] = storeSlug.trim();
    params['todays_deal'] = 1;

    final response = await manager.getWithHeaderAndParam(
      ApiClient.todayDealProducts,
      params: params,
    );

    // print('getFilterProducts: $response');
    return response;
  }

  Future<dynamic> getFilterProducts({
    int? page,
    int? perPage,
    int? shopId,
    int? categoryId,
    int? subCategoryId,
    int? brandId,
    String? status,
    int? isActive, // 1 or 0
    String? search,
    String? storeSlug,
  }) async {
    final APIManager manager = APIManager();

    final Map<String, dynamic> params = {};

    if (page != null) params['page'] = page;
    if (perPage != null) params['per_page'] = perPage;

    if (shopId != null) params['shop_id'] = shopId;
    if (categoryId != null) params['category_id'] = categoryId;
    if (subCategoryId != null) params['sub_category_id'] = subCategoryId;
    if (brandId != null) params['brand_id'] = brandId;

    if (status != null && status.trim().isNotEmpty)
      params['status'] = status.trim();
    if (isActive != null) params['is_active'] = isActive;

    if (search != null && search.trim().isNotEmpty)
      params['search'] = search.trim();
    if (storeSlug != null && storeSlug.trim().isNotEmpty)
      params['store_slug'] = storeSlug.trim();

    final response = await manager.getWithHeaderAndParam(
      ApiClient.listProducts,
      params: params,
    );

    // print('getFilterProducts: $response');
    return response;
  }



  getProductDetail(
    dynamic productIdentifier, {
    String? storeSlug,
  }) async {
    APIManager _manager = APIManager();
    final params = <String, dynamic>{};
    final slug = storeSlug?.trim();
    if (slug != null && slug.isNotEmpty) params['store_slug'] = slug;
    final uri = Uri.parse(
      ApiClient.productDetails + productIdentifier.toString(),
    ).replace(
      queryParameters: params.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    final response = await _manager.getWithHeader(uri.toString(), {});

    print('getProductDetail 4324: ${response}');

    return response;
  }
}
