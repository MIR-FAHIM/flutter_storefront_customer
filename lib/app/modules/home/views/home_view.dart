// lib/app/modules/home/views/home_view.dart

import 'dart:io';
import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/modules/banner/view/home_banner_view.dart';
import 'package:ecom_user_flutter/app/modules/category/controller/category_controller.dart';
import 'package:ecom_user_flutter/app/modules/category/view/home_category_child_row.dart';
import 'package:ecom_user_flutter/app/modules/category/view/home_category_row.dart';
import 'package:ecom_user_flutter/app/modules/home/views/widgets/home_promo_strip.dart';
import 'package:ecom_user_flutter/app/modules/home/views/widgets/home_quick_actions.dart';
import 'package:ecom_user_flutter/app/modules/home/views/widgets/home_search_bar.dart';
import 'package:ecom_user_flutter/app/modules/home/views/widgets/home_section_header.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/view/home_featured_product.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/baby_care_home.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/grocery_home.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/home_all_products.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/home_fasion_product.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/home_restaurant_products.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/medicine_home.dart';
import 'package:ecom_user_flutter/app/modules/notification/controller/notification_controller.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const double _pagePadding = 14;

  PreferredStoreController _preferredStoreController() {
    if (!Get.isRegistered<PreferredStoreController>()) {
      Get.lazyPut<PreferredStoreController>(
        () => PreferredStoreController(),
        fenix: true,
      );
    }
    return Get.find<PreferredStoreController>();
  }

  Future<bool> _confirmExit(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            "Exit App",
            style: TextStyle(
              color: AppColors.homeTextColor1,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            "Are you sure you want to exit?",
            style: TextStyle(
              color: AppColors.homeTextColor2,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "No",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            TextButton(
              onPressed: () => exit(0),
              child: Text(
                "Yes",
                style: TextStyle(
                  color: AppColors.redTextColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _confirmExit(context),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshHome,
            child: Obx(() {
              final preferredStoreController = _preferredStoreController();
              final hasPreferredStores =
                  preferredStoreController.preferredStores.isNotEmpty;
              final isLoadingPreferredStores =
                  preferredStoreController.isLoading.value;
              final preferredStoresError = preferredStoreController.error.value;

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  Obx(() {
                    return SliverToBoxAdapter(
                      child: _PdfStyleHomeHeader(
                        onProfileTap: () {
                          Get.toNamed(Routes.PROFILE)?.then((_) {
                            controller.getUnreadChatCount();
                          });
                        },
                        onSearchTap: () {
                          final slug =
                              Get.find<StoreContextService>().storeSlugOrNull;
                          Get.toNamed(
                            slug == null
                                ? Routes.PRODUCT_FILTER
                                : '/store/$slug/search',
                          );
                        },
                        onMessengerTap: () {
                          Get.toNamed(Routes.SHOP_CHAT_CONVERSATIONS)
                              ?.then((_) {
                            controller.getUnreadChatCount();
                          });
                        },
                        chatBadgeCount: controller.unreadChatCount.value,
                        onScanTap: () {
                          Get.toNamed(Routes.QR_SCAN);
                        },
                        onNotificationTap: () {
                          Get.toNamed(Routes.NOTIFICATIONVIEW);
                        },
                        onWishlistTap: () {},
                      ),
                    );
                  }),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 5),
                  ),
                  if (!hasPreferredStores)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _pagePadding,
                          vertical: 24,
                        ),
                        child: isLoadingPreferredStores
                            ? const Center(child: CircularProgressIndicator())
                            : preferredStoresError.isNotEmpty
                                ? _PreferredStoresLoadError(
                                    message: preferredStoresError,
                                    onRetry: preferredStoreController
                                        .refreshPreferredStores,
                                  )
                                : const _ChooseStorePrompt(),
                      ),
                    ),
                  if (hasPreferredStores) ...[
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),

                    // Main banner, same position as PDF
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _pagePadding),
                        child: HomeBannerCarousel(),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),

                    // Today's Deal, All Brands, Top Seller, Flash Sale, New Arrivals, Free Delivery
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: _pagePadding),
                        child: HomeQuickActionsRow(),
                      ),
                    ),

                    // const SliverToBoxAdapter(
                    //   child: SizedBox(height: 12),
                    // ),
                    //
                    // // Client ad / promo strip
                    // const SliverToBoxAdapter(
                    //   child: HomePromoStrip(),
                    // ),

                    // Featured category section
                    Obx(() {
                      final categoryController = Get.find<CategoryController>();
                      final hasCategories =
                          categoryController.categories.isNotEmpty;
                      final isLoading = categoryController.isLoading.value;

                      if (!isLoading && !hasCategories) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }

                      return SliverToBoxAdapter(
                        child: Column(
                          children: [
                            HomeSectionHeader(
                              title: "Featured Category",
                              actionText: "See All",
                              onTap: () {
                                // Get.toNamed(Routes.CATEGORY_VIEW);
                              },
                            ),
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _pagePadding),
                              child: HomeCategoryRow(),
                            ),
                            const SizedBox(height: 14),
                          ],
                        ),
                      );
                    }),

                    // Featured Product section, PDF uses #00509D with low opacity
                    SliverToBoxAdapter(
                      child: _PdfSectionBlock(
                        backgroundColor:
                            AppColors.primaryColor.withOpacity(0.32),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                        child: const HomeFeaturedProductsSection(),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 14),
                    ),

                    // Medicine or Grocery style product section
                    SliverToBoxAdapter(
                      child: _PdfSectionBlock(
                        backgroundColor: AppColors.backgroundColor,
                        child: HomeGrocerySection(),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 14),
                    ),

                    SliverToBoxAdapter(
                      child: _PdfSectionBlock(
                        backgroundColor: AppColors.backgroundColor,
                        child: HomeMedicineSection(),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 14),
                    ),

                    // Fashion section, PDF uses #A59E83 around 60% opacity
                    SliverToBoxAdapter(
                      child: HomeCategoryChildRow(
                        title: "Fashion",
                        backgroundColor:
                            AppColors.fashionColor.withOpacity(0.60),
                        onSeeAllTap: () {
                          Get.find<ProductController>()
                              .openCategoryWiseProducts(5);
                        },
                        onItemTap: (item) {
                          Get.find<ProductController>()
                              .openCategoryWiseProducts(item.id);
                        },
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 14),
                    ),

                    // Baby care section
                    SliverToBoxAdapter(
                      child: _PdfSectionBlock(
                        backgroundColor: AppColors.backgroundColor,
                        child: HomeBabyCareSection(),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 14),
                    ),

                    // Additional product section placeholder using your existing restaurant widget
                    SliverToBoxAdapter(
                      child: HomeAllProductsSection(),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: 22),
                    ),
                  ],
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _PdfStyleHomeHeader extends StatelessWidget {
  const _PdfStyleHomeHeader({
    required this.onSearchTap,
    required this.onMessengerTap,
    required this.onNotificationTap,
    required this.onWishlistTap,
    required this.onScanTap,
    required this.onProfileTap,
    required this.chatBadgeCount,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onMessengerTap;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onWishlistTap;
  final VoidCallback onScanTap;
  final int chatBadgeCount;

  @override
  Widget build(BuildContext context) {
    final storeContext = Get.find<StoreContextService>();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeaderCircleIcon(
                icon: Icons.supervised_user_circle_outlined,
                label: "profile",
                onTap: onProfileTap,
              ),
              const SizedBox(width: 8),
              _HeaderCircleIcon(
                icon: Icons.messenger_outline_rounded,
                label: "messenger",
                badgeCount: chatBadgeCount,
                onTap: onMessengerTap,
              ),
              const SizedBox(width: 8),
              _HeaderCircleIcon(
                icon: Icons.qr_code_2_rounded,
                label: "scan",
                onTap: onScanTap,
              ),
              const SizedBox(width: 8),
              Obx(
                () => _HeaderCircleIcon(
                  icon: Icons.notifications_none_rounded,
                  label: "notification",
                  badgeCount:
                      Get.find<NotificationController>().unreadCount.value,
                  onTap: onNotificationTap,
                ),
              ),
              const SizedBox(width: 8),
              _HeaderCircleIcon(
                icon: Icons.favorite_border_rounded,
                label: "wishlist",
                onTap: onWishlistTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          HomeSearchBar(
            hintText: "Search anything ...",
            onTap: onSearchTap,
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }
}

String _asHeaderImageUrl(String value) {
  if (value.startsWith('http://') || value.startsWith('https://')) return value;
  final cleanValue = value.startsWith('/') ? value.substring(1) : value;
  return '${CompanyData.image_file_url}/$cleanValue';
}

class _HeaderCircleIcon extends StatelessWidget {
  const _HeaderCircleIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.primaryColor,
              size: 19,
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              right: -2,
              top: -5,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.golden,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    badgeCount > 9 ? "9+" : badgeCount.toString(),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChooseStorePrompt extends StatelessWidget {
  const _ChooseStorePrompt();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.storefront_outlined,
            size: 64, color: AppColors.primaryColor),
        const SizedBox(height: 16),
        Text(
          'Choose your preferred store',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Scan a shop QR code or find a shop with its 6 digit code.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: () => Get.toNamed(Routes.QR_SCAN),
          icon: const Icon(Icons.qr_code_scanner_rounded),
          label: const Text('Scan Shop QR'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => Get.toNamed(Routes.PREFERRED_STORE_CODE_LOOKUP),
          icon: const Icon(Icons.pin_outlined),
          label: const Text('Find Shop by Code'),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => Get.toNamed(Routes.SHOP_LIST),
          icon: const Icon(Icons.storefront_rounded),
          label: const Text('Browse Stores'),
        ),
      ],
    );
  }
}

class _PreferredStoresLoadError extends StatelessWidget {
  const _PreferredStoresLoadError(
      {required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline_rounded, size: 48),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry'),
        ),
      ],
    );
  }
}

class _PdfSectionBlock extends StatelessWidget {
  const _PdfSectionBlock({
    required this.child,
    required this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(vertical: 0),
  });

  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isWhite = backgroundColor.value == AppColors.backgroundColor.value;

    if (isWhite) {
      return Padding(
        padding: padding,
        child: child,
      );
    }

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
