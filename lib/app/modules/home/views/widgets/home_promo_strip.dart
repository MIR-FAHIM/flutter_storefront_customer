import 'package:ecom_user_flutter/app/modules/banner/controller/banner_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api_providers/company_data.dart';

class HomePromoStrip extends GetView<BannerController> {
  const HomePromoStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final banners = controller.bannerData
          .where((item) => item.isActive != false)
          .toList();

      if (banners.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 125,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: banners.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, index) {
            final banner = banners[index];

            return _PromoCard(
              banner: banner,
              onTap: () => _handleBannerTap(banner),
            );
          },
        ),
      );
    });
  }

  void _handleBannerTap(dynamic banner) {
    final productId = banner.relatedProductId;
    final categoryId = banner.relatedCategoryId;

    if (productId != null) {
      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().getProductDetail(productId);
      }
      return;
    }

    if (categoryId != null) {
      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().openCategoryWiseProducts(categoryId);
      }
    }
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.banner,
    required this.onTap,
  });

  final dynamic banner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    final imageUrl = banner?.image.resolvedUrl(baseUrl: CompanyData.image_file_url);


    final hasAction =
        banner.relatedProductId != null || banner.relatedCategoryId != null;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: hasAction ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 260,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: _BannerImage(imageUrl: imageUrl),
        ),
      ),
    );
  }


}

class _BannerImage extends StatelessWidget {
  const _BannerImage({
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const Center(
        child: Icon(
          Icons.local_offer_outlined,
          color: Colors.black45,
          size: 34,
        ),
      );
    }

    return Image.network(
      imageUrl!,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, __, ___) {
        return const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Colors.black45,
            size: 34,
          ),
        );
      },
    );
  }
}