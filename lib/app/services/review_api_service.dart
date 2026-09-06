import 'package:ecom_user_flutter/app/api_providers/api_manager.dart';
import 'package:ecom_user_flutter/app/api_providers/api_url.dart';

class ReviewApiService {
  final APIManager _manager;

  ReviewApiService({APIManager? manager}) : _manager = manager ?? APIManager();

  Future<dynamic> addReview({
    required int userId,
    required int shopId,
    int? productId,
    required String comment,
    required int starCount,
    required Map<String, String> headers,
  }) {
    return _manager.postAPICallWithEncoded(
      ApiClient.addReview,
      {
        'user_id': userId,
        'shop_id': shopId,
        'product_id': productId,
        'comment': comment,
        'star_count': starCount,
      },
      headers,
    );
  }

  Future<dynamic> getReviewsByShop(int shopId) {
    return _manager.get('${ApiClient.reviewsByShop}$shopId');
  }
}
