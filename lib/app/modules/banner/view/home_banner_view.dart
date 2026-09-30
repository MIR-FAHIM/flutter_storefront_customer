import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/models/ecom/banner_model.dart';
import 'package:ecom_user_flutter/app/modules/banner/controller/banner_controller.dart';
import 'package:ecom_user_flutter/app/modules/gamification/view/storefront_gamification_header.dart';
import 'package:ecom_user_flutter/app/modules/review/view/shop_reviews_section.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/shop_model.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBannerCarousel extends GetView<BannerController> {
  const HomeBannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.isLoading.value;
      final banners = controller.bannerData;
      final shop = controller.shopDetails.value;

      if (loading && banners.isEmpty && shop == null) {
        return const _SkeletonBanner();
      }

      if (shop != null) {
        return _ShopHeader(shop: shop, fallbackBanners: banners);
      }

      if (banners.isEmpty) {
        return const SizedBox.shrink();
      }

      return _ApiCarousel(banners: banners);
    });
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({required this.shop, required this.fallbackBanners});

  final Datum shop;
  final List<BannerData> fallbackBanners;

  @override
  Widget build(BuildContext context) {
    final bannerUrl = _mediaUrl(shop.banner);
    final logoUrl = _mediaUrl(shop.logo);
    final address = [
      shop.address,
      shop.area?.toString(),
      shop.district?.toString()
    ].where((value) => value != null && value.trim().isNotEmpty).join(', ');
    final rating = shop.averageReviewRating.toDouble().toStringAsFixed(1);
    final totalReviews = shop.totalReviews;
    final storeContext = Get.find<StoreContextService>();
    final chatShopId = shop.id ?? storeContext.activeStoreId.value;
    final shopName = (shop.shopName ?? shop.name ?? 'Preferred Shop'.tr).trim();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cover Photo & Logo Section
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: bannerUrl != null
                      ? Image.network(
                          bannerUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xffeeeeee)),
                        )
                      : (fallbackBanners.isNotEmpty
                          ? _ApiCarousel(banners: fallbackBanners, height: 120)
                          : const ColoredBox(color: Color(0xffeeeeee))),
                ),
              ),
              // Overlapping Logo
              Positioned(
                bottom: -28,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: logoUrl == null ? null : NetworkImage(logoUrl),
                    child: logoUrl == null
                        ? const Icon(Icons.storefront_outlined, size: 32, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              // Gamification Widget overlapping bottom right
              Positioned(
                bottom: -16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))
                    ],
                  ),
                  child: const StorefrontRewardAction(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 36), // Spacer for overlapping logo
          
          // Store Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (address.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(color: Colors.black54, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
          
          // Quick Actions Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (shop.id != null)
                  _buildActionItem(
                    icon: Icons.star_rounded,
                    label: '$rating ($totalReviews)',
                    color: Colors.amber.shade700,
                    onTap: () => Get.to(() => ShopReviewsScreen(shopId: shop.id!, shopName: shopName)),
                  ),
                if (chatShopId != null)
                  _buildActionItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Shop Chat'.tr,
                    color: AppColors.primaryColor,
                    onTap: () => Get.toNamed(Routes.SHOP_CHAT_THREAD, arguments: {'shop_id': chatShopId}),
                  ),
                if (shop.id != null)
                  _buildActionItem(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Due'.tr,
                    color: Colors.red,
                    onTap: () => Get.toNamed(Routes.BAKI_LEDGER, arguments: {'shop_id': shop.id}),
                  ),
                if (shop.id == null && chatShopId == null)
                  _buildActionItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Shop Chat'.tr,
                    color: AppColors.primaryColor,
                    onTap: () => Get.toNamed(Routes.SHOP_CHAT_CONVERSATIONS),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}

String? _mediaUrl(MediaFile? media) {
  if (media == null) return null;
  final direct = media.url?.trim();
  if (direct != null && direct.isNotEmpty) return direct;
  final fileName = media.fileName?.trim();
  if (fileName == null || fileName.isEmpty) return null;
  final base = CompanyData.image_file_url.endsWith('/')
      ? CompanyData.image_file_url.substring(0, CompanyData.image_file_url.length - 1)
      : CompanyData.image_file_url;
  return '$base/${fileName.startsWith('/') ? fileName.substring(1) : fileName}';
}

class _ApiCarousel extends StatefulWidget {
  const _ApiCarousel({required this.banners, this.height = 140});
  final List<BannerData> banners;
  final double height;

  @override
  State<_ApiCarousel> createState() => _ApiCarouselState();
}

class _ApiCarouselState extends State<_ApiCarousel> {
  final PageController _page = PageController(viewportFraction: 1);
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.banners.length;

    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: PageView.builder(
              controller: _page,
              itemCount: count,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => _BannerImage(b: widget.banners[i]),
            ),
          ),
        ),
        // Dots only if not acting as a fallback background banner
        if (widget.height == 140) ...[
          const SizedBox(height: 8),
          _Dots(count: count, index: _index),
        ]
      ],
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.b});
  final BannerData b;

  @override
  Widget build(BuildContext context) {
    final imageUrl = b.image?.resolvedUrl(baseUrl: CompanyData.image_file_url);

    if (imageUrl == null || imageUrl.trim().isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: const Center(
          child: Icon(Icons.image_outlined, size: 42, color: Colors.black54),
        ),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade100,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, size: 42, color: Colors.black54),
        ),
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade100,
          child: const Center(
            child: SizedBox(height: 22, width: 22, child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: active ? 20 : 6,
          decoration: BoxDecoration(
            color: active ? Colors.black87 : Colors.black26,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _SkeletonBanner extends StatelessWidget {
  const _SkeletonBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 140,
        width: double.infinity,
        color: Colors.grey.shade200,
      ),
    );
  }
}
