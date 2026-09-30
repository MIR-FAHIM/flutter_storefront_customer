// lib/app/modules/home/widgets/home_quick_actions.dart

import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeQuickActionsRow extends StatelessWidget {
  const HomeQuickActionsRow({super.key});

  static const Color _todayDealColor = Color(0xFFDF7529);
  static const Color _allBrandsColor = Color(0xFF428789);
  static const Color _topSellerColor = Color(0xFFAD792D);
  static const Color _flashSaleColor = Color(0xFF2B2C6C);
  static const Color _newArrivalColor = Color(0xFFAF1D5B);
  static const Color _freeDeliveryColor = Color(0xFFBD4D4C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionItem(
              icon: Icons.event_available_outlined,
              label: "Todays Deal",
              color: _todayDealColor,
              onTap: () {
                Get.find<ProductController>().openTodayDealProducts();
              },
            ),
          ),
          Expanded(
            child: _QuickActionItem(
              icon: Icons.lightbulb_outline_rounded,
              label: "All Brands",
              color: _allBrandsColor,
              onTap: () {
                Get.toNamed(Routes.BRAND_LIST);
              },
            ),
          ),
          Expanded(
            child: _QuickActionItem(
              icon: Icons.workspace_premium_outlined,
              label: "Top Seller",
              color: _topSellerColor,
              onTap: () {
                Get.toNamed(Routes.SHOP_LIST);
              },
            ),
          ),
          Expanded(
            child: _QuickActionItem(
              icon: Icons.bolt_outlined,
              label: "Flash Sale",
              color: _flashSaleColor,
              onTap: () {
                // Later: Get.toNamed(Routes.FLASH_SALE);
              },
            ),
          ),
          Expanded(
            child: _QuickActionItem(
              icon: Icons.shopping_bag_outlined,
              label: "New Arrivals",
              color: _newArrivalColor,
              onTap: () {
                // Later: Get.toNamed(Routes.NEW_ARRIVALS);
              },
            ),
          ),
          Expanded(
            child: _QuickActionItem(
              icon: Icons.emoji_events_outlined,
              label: "Reward Races",
              color: const Color(0xFFF2C94C), // Golden color
              onTap: () {
                Get.toNamed(Routes.MY_REWARD_RACES);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}