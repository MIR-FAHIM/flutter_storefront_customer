import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreProfileView extends StatelessWidget {
  const StoreProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final storeService = Get.find<StoreContextService>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Store Header with Back Button
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Back button and title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Store Profile',
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Store Logo and Info
                  Obx(
                    () {
                      final logo = storeService.activeStoreLogo.value;
                      final storeName = storeService.activeStoreName.value;
                      final slug = storeService.activeStoreSlug.value;

                      return Column(
                        children: [
                          // Logo
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            backgroundImage:
                                logo.isEmpty ? null : NetworkImage(logo),
                            child: logo.isEmpty
                                ? Icon(
                                    Icons.storefront_rounded,
                                    color: AppColors.textWhite,
                                    size: 50,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 12),
                          // Store Name
                          Text(
                            storeName.isEmpty ? slug : storeName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Store Slug
                          Text(
                            slug,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textWhite.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Store Details Card
                    _StoreDetailCard(),
                    const SizedBox(height: 20),
                    // Welcome Message
                    Text(
                      'Welcome to Your Store',
                      style: TextStyle(
                        color: AppColors.homeTextColor1,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse our products and add them to your cart. Enjoy special offers and deals available only in this store.',
                      style: TextStyle(
                        color: AppColors.homeTextColor2,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Browse Products Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.ROOT);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Browse Products',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            icon: Icons.info_outline_rounded,
            label: 'Store Status',
            value: 'Active',
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Category',
            value: 'Multi-category Store',
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.star_outline_rounded,
            label: 'Rating',
            value: '★ 4.8 (120+ reviews)',
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.local_shipping_outlined,
            label: 'Delivery',
            value: 'Fast & Reliable',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.homeTextColor2,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.homeTextColor1,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
