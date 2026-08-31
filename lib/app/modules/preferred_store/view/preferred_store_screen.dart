import 'package:ecom_user_flutter/models/ecom/product/preferred_store_model.dart';
import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_controller.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/store_context_service.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferredStoreScreen extends GetView<PreferredStoreController> {
  const PreferredStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.preferredStores.isEmpty && !controller.isLoading.value) {
        controller.getPreferredStores(reset: true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Preferred Stores'),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.preferredStores.isEmpty) {
          return const _PreferredStoreSkeleton();
        }

        if (controller.error.value.isNotEmpty &&
            controller.preferredStores.isEmpty) {
          return _ErrorState(
            message: controller.error.value,
            onRetry: () => controller.getPreferredStores(reset: true),
          );
        }

        if (controller.preferredStores.isEmpty) {
          return const _EmptyState();
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: controller.refreshPreferredStores,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.axis == Axis.vertical &&
                  notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 220) {
                controller.loadMorePreferredStores();
              }

              return false;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 110),
              itemCount: controller.preferredStores.length +
                  (controller.isMoreLoading.value ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= controller.preferredStores.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                return _PreferredStoreCard(
                  item: controller.preferredStores[index],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class _PreferredStoreCard extends GetView<PreferredStoreController> {
  const _PreferredStoreCard({
    required this.item,
  });

  final PreferredStoreItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = item.status.trim().isEmpty ? 'active' : item.status.trim();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openOrActivateStore(item),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: item.logoUrl.isEmpty
                    ? Icon(
                        Icons.storefront_rounded,
                        color: AppColors.primaryColor,
                        size: 26,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.logoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.storefront_rounded,
                            color: AppColors.primaryColor,
                            size: 26,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusChip(status: status),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.link_rounded,
                      text: item.slug.isEmpty ? 'Store slug unavailable' : item.slug,
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      text: item.phoneText,
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      text: _locationText(item),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      final active = controller.isActive(item);
                      final activating = controller.isActivating(item);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: controller.isRemoving.value
                                ? null
                                : () => controller.removePreference(item),
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Remove'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.errorColor,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (active)
                            const Text(
                              'Active Store',
                              style: TextStyle(
                                color: Color(0xFF15803D),
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            )
                          else
                            ElevatedButton(
                              onPressed: activating
                                  ? null
                                  : () => controller.setActiveStore(item),
                              child: activating
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text('Set Active'),
                            ),
                        ],
                      );
                    },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openOrActivateStore(PreferredStoreItem item) {
    final store = item.seller?.shop ?? item.seller?.store;
    final slug = store?.slug?.trim();

    if (slug == null || slug.isEmpty) return;

    if (!controller.isActive(item)) {
      controller.setActiveStore(item);
      return;
    }

    Get.find<StoreContextService>().setActiveStore(
      slug: slug,
      id: store?.id,
      sellerId: item.resolvedSellerId,
      name: store?.shopName ?? store?.name ?? item.displayName,
      logo: item.logoUrl,
      banner: item.bannerUrl,
    );
    Get.offAllNamed('/store/$slug');
  }

  String _locationText(PreferredStoreItem item) {
    final values = [item.addressText, item.districtText]
        .where((value) => value != '-')
        .toList();
    return values.isEmpty ? 'Address unavailable' : values.join(', ');
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF16A34A).withOpacity(0.12)
            : AppColors.textMuted.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.capitalizeFirst ?? status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isActive ? const Color(0xFF15803D) : AppColors.textMuted,
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.storefront_outlined,
                size: 40,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'No preferred stores yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Stores you add from the home page will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.SHOP_LIST),
              icon: const Icon(Icons.search_rounded),
              label: const Text('Browse Stores'),
            ),
          ],
        ),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.errorColor,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferredStoreSkeleton extends StatelessWidget {
  const _PreferredStoreSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 110),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Container(
          height: 132,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderColor),
          ),
        );
      },
    );
  }
}
