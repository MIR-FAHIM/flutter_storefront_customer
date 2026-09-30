// lib/app/modules/products/view/widgets/home_buy_again_section.dart

import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/product_card_widget.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBuyAgainSection extends GetView<ProductController> {
  const HomeBuyAgainSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.buyAgainProducts;

      // Only show the section if there is data
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
              title: "Buy Again",
              onSeeAllTap: () {
                final slug = controller.activeStoreSlug;
                Get.toNamed(
                  slug == null
                      ? Routes.PRODUCT_FILTER
                      : '/store/$slug/products',
                );
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: Get.height * .25,
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
            child: Row(
              children: [
                Icon(
                  Icons.replay_rounded,
                  color: AppColors.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
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
              ],
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
