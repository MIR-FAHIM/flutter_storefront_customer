import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/models/ecom/banner_model.dart';
import 'package:ecom_user_flutter/app/modules/banner/controller/banner_controller.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/shop_model.dart';
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
    final address = [shop.address, shop.area?.toString(), shop.district?.toString()]
        .where((value) => value != null && value.trim().isNotEmpty)
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (bannerUrl == null && fallbackBanners.isNotEmpty)
          _ApiCarousel(banners: fallbackBanners),
        if (bannerUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: Image.network(
                bannerUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xffeeeeee),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 29,
                  backgroundImage: logoUrl == null ? null : NetworkImage(logoUrl),
                  child: logoUrl == null
                      ? const Icon(Icons.storefront_outlined)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (shop.shopName ?? shop.name ?? 'Preferred Shop').trim(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    if (address.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(address, style: const TextStyle(color: Colors.black54)),
                    ],
                  ],
                ),
              )
              ],
            ),
          ),
      ],
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
  const _ApiCarousel({required this.banners});
  final List<BannerData> banners;

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
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 140, // adjust to your design (screenshot looks around this)
            width: double.infinity,
            child: PageView.builder(
              controller: _page,
              itemCount: count,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => _BannerImage(b: widget.banners[i]),
            ),
          ),
        ),


        const SizedBox(height: 8),

        _Dots(count: count, index: _index),
      ],
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.b});
  final BannerData b;

  @override
  Widget build(BuildContext context) {
    // Preferred: image.url, else build from file_name + base url
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
      fit: BoxFit.cover, // full width banner style
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
