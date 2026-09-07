import 'package:ecom_user_flutter/app/models/ecom/review_model.dart';
import 'package:ecom_user_flutter/app/modules/review/controller/shop_reviews_controller.dart';
import 'package:ecom_user_flutter/app/modules/review/view/add_review_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopReviewsScreen extends StatelessWidget {
  const ShopReviewsScreen({required this.shopId, this.shopName, super.key});

  final int shopId;
  final String? shopName;

  String get _tag => 'shop-reviews-$shopId';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ShopReviewsController(shopId: shopId),
      tag: _tag,
    );

    return Scaffold(
      appBar: AppBar(
          title: Text(shopName?.trim().isNotEmpty == true
              ? '${shopName!} reviews'
              : 'Shop reviews')),
      body: ShopReviewsSection(controller: controller),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.bottomSheet(
          AddReviewSheet(controller: controller),
          isScrollControlled: true,
          ignoreSafeArea: false,
        ),
        icon: const Icon(Icons.rate_review_outlined),
        label: const Text('Add Review'),
      ),
    );
  }
}

class ShopReviewsSection extends StatelessWidget {
  const ShopReviewsSection({required this.controller, super.key});

  final ShopReviewsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.reviews.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value.isNotEmpty && controller.reviews.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => controller.loadReviews(refresh: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.28),
              Center(child: Text(controller.error.value)),
              const SizedBox(height: 12),
              Center(
                  child: TextButton.icon(
                      onPressed: controller.loadReviews,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'))),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.loadReviews(refresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            Row(
              children: [
                const Expanded(
                    child: Text('Customer reviews',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700))),
                Text('${controller.count.value}'),
              ],
            ),
            const SizedBox(height: 12),
            if (controller.reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Column(
                  children: [
                    Icon(Icons.rate_review_outlined,
                        size: 48, color: Colors.black38),
                    SizedBox(height: 12),
                    Text('No reviews yet'),
                    SizedBox(height: 4),
                    Text('Be the first to share your experience.'),
                  ],
                ),
              )
            else
              ...controller.reviews
                  .map((review) => _ReviewTile(review: review)),
          ],
        ),
      );
    });
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final name = review.user?.name?.trim();
    final reviewer = name?.isNotEmpty == true ? name! : 'Customer';
    final stars = (review.starCount ?? 0).clamp(0, 5);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(reviewer,
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                Row(
                    children: List.generate(
                        5,
                        (index) => Icon(
                            index < stars
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 18,
                            color: Colors.amber.shade700))),
              ],
            ),
            if ((review.comment ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(review.comment!.trim()),
            ],
          ],
        ),
      ),
    );
  }
}
