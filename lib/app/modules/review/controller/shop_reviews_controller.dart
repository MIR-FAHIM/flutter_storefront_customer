import 'package:ecom_user_flutter/app/models/ecom/review_model.dart';
import 'package:ecom_user_flutter/app/repositories/review_repository.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:get/get.dart';

class ShopReviewsController extends GetxController {
  ShopReviewsController({required this.shopId, ReviewRepository? repository})
      : _repository = repository ?? ReviewRepository();

  final int shopId;
  final ReviewRepository _repository;
  final reviews = <Review>[].obs;
  final count = 0.obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadReviews();
  }

  Future<void> loadReviews({bool refresh = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    if (refresh) error.value = '';

    try {
      final response = await _repository.getReviewsByShop(shopId);
      reviews.assignAll(response.items);
      count.value = response.count;
      error.value = '';
    } catch (exception) {
      error.value = exception.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> submitReview({
    required int starCount,
    required String comment,
  }) async {
    final userId = Get.find<AuthService>().currentUser.value.data?.user?.id;
    if (userId == null) {
      error.value = 'Please log in to add a review.';
      return false;
    }

    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    try {
      await _repository.addReview(
        userId: userId,
        shopId: shopId,
        productId: null,
        comment: comment,
        starCount: starCount,
      );
      await loadReviews(refresh: true);
      return true;
    } catch (exception) {
      error.value = exception.toString();
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
