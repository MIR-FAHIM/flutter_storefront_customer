// lib/app/modules/products/view/home_featured_product.dart

import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/product_card_widget.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFeaturedProductsSection extends GetView<ProductController> {
  const HomeFeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isFeaturedLoading.value;
      final products = controller.products;

      if (loading && products.isEmpty) {
        return const _FeaturedProductSkeleton();
      }

      if (products.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,

        padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: "Featured Product",
              onSeeAllTap: () {
                final slug = controller.activeStoreSlug;
                Get.toNamed(
                  slug == null
                      ? Routes.PRODUCT_FILTER
                      : '/store/$slug/featured-products',
                );
              },
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: Get.height*.25,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  return ProductCard(
                    product: products[index],
                    width: 128,
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onSeeAllTap,
  });

  final String title;
  final VoidCallback onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                height: 1.1,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onSeeAllTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              child: Text(
                "See All",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedProductSkeleton extends StatelessWidget {
  const _FeaturedProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryColor.withOpacity(0.32),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _SkeletonBox(
                  width: 135,
                  height: 20,
                  radius: 6,
                ),
                const Spacer(),
                _SkeletonBox(
                  width: 42,
                  height: 12,
                  radius: 6,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 214,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, __) {
                return const _ProductSkeletonCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSkeletonCard extends StatelessWidget {
  const _ProductSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.borderColor,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 52,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Expanded(
            flex: 48,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(7),
              color: const Color(0xFFF3F4F6),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(width: 90, height: 10, radius: 5),
                  SizedBox(height: 5),
                  _SkeletonBox(width: 70, height: 9, radius: 5),
                  Spacer(),
                  _SkeletonBox(width: 55, height: 14, radius: 6),
                  SizedBox(height: 6),
                  _SkeletonBox(width: 100, height: 9, radius: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
