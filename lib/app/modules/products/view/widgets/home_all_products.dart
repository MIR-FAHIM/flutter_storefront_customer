// lib/app/modules/products/view/widgets/home_all_products_section.dart

import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/product_card_widget.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAllProductsSection extends GetView<ProductController> {
  const HomeAllProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isHomeAllProductsLoading.value;

      final allProducts = controller.homeAllProducts;
      final visibleProducts = allProducts.take(14).toList();

      if (loading && allProducts.isEmpty) {
        return const _AllProductSkeleton();
      }

      if (allProducts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        color: AppColors.allProductBg,
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: "All Product",
              onSeeAllTap: () {
                final slug = controller.activeStoreSlug;
                Get.toNamed(
                  slug == null ? Routes.PRODUCT_FILTER : '/store/$slug/products',
                );
              },
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visibleProducts.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  if (index == visibleProducts.length) {
                    return _SeeAllProductCard(
                      onTap: () {
                        final slug = controller.activeStoreSlug;
                        Get.toNamed(
                          slug == null
                              ? Routes.PRODUCT_FILTER
                              : '/store/$slug/products',
                        );
                      },
                    );
                  }

                  return ProductCard(
                    product: visibleProducts[index],
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

class _SeeAllProductCard extends StatelessWidget {
  const _SeeAllProductCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.35),
              width: 0.9,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "See All",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "Products",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor.withOpacity(0.65),
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllProductSkeleton extends StatelessWidget {
  const _AllProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.allProductBg,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _SkeletonBox(
                  width: 110,
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

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.58,
              ),
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
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
