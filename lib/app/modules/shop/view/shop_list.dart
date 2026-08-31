import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/shop_model.dart';
import 'package:ecom_user_flutter/app/modules/shop/controller/shop_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopListView extends GetView<ShopController> {
  const ShopListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'All Shops',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoadingShops.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error.value.isNotEmpty) {
          return _ErrorState(
            message: controller.error.value,
            onRetry: controller.getShops,
          );
        }

        final shops = controller.shopList;

        if (shops.isEmpty) {
          return const _EmptyState();
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemCount: shops.length,
          itemBuilder: (_, index) {
            return _ShopCard(item: shops[index]);
          },
        );
      }),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({
    required this.item,
  });

  final Datum item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final logo = _asImageUrl(item.logo?.fileName);
    final name = item.shopName ?? item.name ?? '-';
    final status = item.status ?? 'inactive';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.find<ShopController>().openStore(item);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  color: Colors.grey.shade100,
                  child: logo.isEmpty
                      ? const Icon(
                    Icons.storefront,
                    size: 42,
                    color: Colors.black45,
                  )
                      : Image.network(
                    logo,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.storefront,
                        size: 42,
                        color: Colors.black45,
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: status.toLowerCase() == 'active'
                              ? const Color(0xFF16A34A)
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status.capitalizeFirst ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Obx(() {
                      final shopController = Get.find<ShopController>();
                      final isAdded = shopController.isStorePreferred(item);
                      final isLoading = shopController.isAddingPreference.value;

                      return OutlinedButton(
                        onPressed: isAdded || isLoading
                            ? null
                            : () {
                                shopController.addStorePreference(item);
                              },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          side: BorderSide(
                            color: isAdded
                                ? const Color(0xFF16A34A)
                                : AppColors.primaryColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isAdded ? 'Added' : 'Add Preference',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isAdded
                                ? const Color(0xFF16A34A)
                                : AppColors.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _asImageUrl(String? fileName) {
  if (fileName == null || fileName.trim().isEmpty) {
    return '';
  }

  if (fileName.startsWith('http')) {
    return fileName;
  }

  return "${CompanyData.image_file_url}/$fileName";
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.storefront,
            size: 56,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          const Text(
            "No shops found",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
