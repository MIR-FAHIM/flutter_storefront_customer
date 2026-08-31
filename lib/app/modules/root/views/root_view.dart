import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/modules/delivery/controller/delivery_controller.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecom_user_flutter/app/modules/global_widgets/main_drawer_widget.dart';
import 'package:ecom_user_flutter/app/modules/home/controllers/home_controller.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          final value = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Are you sure you want to exit?'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
          return value == true;
        },
        child: Scaffold(
          body: controller.currentPage,

          bottomNavigationBar: Obx(() {
            return SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SmartBottomBarItem(
                      icon: 'assets/icons/home.png',
                      label: 'Home',
                      isSelected: controller.currentIndex.value == 0,
                      onTap: () {
                        controller.currentIndex.value = 0;
                        if (!Get.isRegistered<HomeController>()) {
                          Get.lazyPut<HomeController>(() => HomeController());
                        }
                      },
                    ),
                    _SmartBottomBarItem(
                      icon: 'assets/icons/order.png',
                      label: 'Order',
                      isSelected: controller.currentIndex.value == 1,
                      onTap: () {
                        controller.currentIndex.value = 1;
                        if (!Get.isRegistered<DeliveryController>()) {
                          Get.lazyPut<DeliveryController>(() => DeliveryController());
                        }
                      },
                    ),
                    _SmartBottomBarItem(
                      icon: 'assets/icons/cart.png',
                      label: 'Cart',
                      count: Get.find<CartController>().cart.value?.totalItems ?? 0,
                      isCart: true,
                      isSelected: controller.currentIndex.value == 2,
                      onTap: () {
                        controller.currentIndex.value = 2;
                        if (!Get.isRegistered<DeliveryController>()) {
                          Get.lazyPut<DeliveryController>(() => DeliveryController());
                        }
                      },
                    ),
                    _SmartBottomBarItem(
                      iconData: Icons.storefront_rounded,
                      label: 'Store',
                      isSelected: controller.currentIndex.value == 3,
                      onTap: () {
                        controller.currentIndex.value = 3;
                        if (!Get.isRegistered<PreferredStoreController>()) {
                          Get.lazyPut<PreferredStoreController>(
                            () => PreferredStoreController(),
                            fenix: true,
                          );
                        }
                        Get.find<PreferredStoreController>()
                            .getPreferredStores(reset: true);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}

class _SmartBottomBarItem extends StatelessWidget {
  const _SmartBottomBarItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.iconData,
    this.count = 0,
    this.isCart = false,
  });

  final String? icon;
  final IconData? iconData;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;
  final bool isCart;

  static const Color _selectedColor = Color(0xFF1F214C);
  static const Color _unselectedColor = Color(0xFF9CA3AF);
  static const Color _badgeColor = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isSelected ? _selectedColor : _unselectedColor;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? _selectedColor.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 180),
                    scale: isSelected ? 1.12 : 1.0,
                    child: iconData == null
                        ? Image.asset(
                            icon!,
                            height: 23,
                            width: 23,
                            color: activeColor,
                          )
                        : Icon(
                            iconData,
                            size: 24,
                            color: activeColor,
                          ),
                  ),

                  if (isCart && count > 0)
                    Positioned(
                      right: -10,
                      top: -9,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 17,
                          minHeight: 17,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _badgeColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 1.4),
                        ),
                        child: Text(
                          count > 99 ? '99+' : count.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  color: activeColor,
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
