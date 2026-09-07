import 'package:ecom_user_flutter/app/models/ecom/review_model.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/review_api_service.dart';
import 'package:get/get.dart';

class ReviewRepository {
  final ReviewApiService _service;

  ReviewRepository({ReviewApiService? service})
      : _service = service ?? ReviewApiService();

  Map<String, String> get _authHeaders {
    final token = Get.find<AuthService>().currentUser.value.data?.token;
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<Review> addReview({
    required int userId,
    required int shopId,
    int? productId,
    required String comment,
    required int starCount,
  }) async {
    final response = await _service.addReview(
      userId: userId,
      shopId: shopId,
      productId: productId,
      comment: comment,
      starCount: starCount,
      headers: _authHeaders,
    );
    final json = _responseMap(response);
    if (json['status'] != 'success') {
      throw ReviewApiException(_errorMessage(json));
    }
    final data = json['data'];
    if (data is! Map) throw const ReviewApiException('Invalid review response');
    return Review.fromJson(Map<String, dynamic>.from(data));
  }

  Future<ReviewListResponse> getReviewsByShop(int shopId) async {
    final response = await _service.getReviewsByShop(shopId);
    final json = _responseMap(response);
    if (json['status'] != 'success') {
      throw ReviewApiException(_errorMessage(json));
    }
    return ReviewListResponse.fromJson(json);
  }

  Map<String, dynamic> _responseMap(dynamic response) => response is Map
      ? Map<String, dynamic>.from(response)
      : <String, dynamic>{};

  String _errorMessage(Map<String, dynamic> json) {
    final errors = json['errors'];
    if (errors is Map) {
      final first = errors.values.whereType<List>().expand((value) => value);
      if (first.isNotEmpty) return first.first.toString();
    }
    return json['message']?.toString() ?? 'Something went wrong';
  }
}

class ReviewApiException implements Exception {
  final String message;

  const ReviewApiException(this.message);

  @override
  String toString() => message;
}
