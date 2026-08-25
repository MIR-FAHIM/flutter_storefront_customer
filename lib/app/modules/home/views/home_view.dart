// lib/app/modules/home/views/home_view.dart

import 'dart:io';
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
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/auth_service.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const double _pagePadding = 14;

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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _PdfStyleHomeHeader(
                  onSearchTap: () {
                    Get.toNamed(Routes.PRODUCT_FILTER);
                  },
                  onMessengerTap: () {},
                  onNotificationTap: () {
                    // Get.toNamed(Routes.NOTIFICATIONVIEW);
                  },
                  onWishlistTap: () {},
                ),
              ),

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

              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),

              // Client ad / promo strip
              const SliverToBoxAdapter(
                child: HomePromoStrip(),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 14),
              ),

              // Featured category section
              SliverToBoxAdapter(
                child: HomeSectionHeader(
                  title: "Featured Category",
                  actionText: "See All",
                  onTap: () {
                    // Get.toNamed(Routes.CATEGORY_VIEW);
                  },
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: _pagePadding),
                  child: HomeCategoryRow(),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 14),
              ),

              // Featured Product section, PDF uses #00509D with low opacity
              SliverToBoxAdapter(
                child: _PdfSectionBlock(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.32),
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
                  backgroundColor: AppColors.fashionColor.withOpacity(0.60),
                  onSeeAllTap: () {
                    Get.find<ProductController>().openCategoryWiseProducts(5);
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
  });

  final VoidCallback onSearchTap;
  final VoidCallback onMessengerTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onWishlistTap;

  @override
  Widget build(BuildContext context) {
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
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.white.withOpacity(0.18),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.textWhite,
                  size: 28,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (Get.find<AuthService>().currentUser.value.data == null)
                      Text(
                        "Customer",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    if (Get.find<AuthService>().currentUser.value.data != null)
                      Text(
                        Get.find<AuthService>()
                            .currentUser
                            .value
                            .data!
                            .user!
                            .name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                  ],
                ),
              ),
              _HeaderCircleIcon(
                icon: Icons.messenger_outline_rounded,
                label: "messenger",
                onTap: onMessengerTap,
              ),
              const SizedBox(width: 8),
              _HeaderCircleIcon(
                icon: Icons.notifications_none_rounded,
                label: "notification",
                badgeCount: 2,
                onTap: onNotificationTap,
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
