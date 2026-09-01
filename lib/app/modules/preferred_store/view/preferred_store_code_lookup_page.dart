import 'package:ecom_user_flutter/app/modules/preferred_store/controller/preferred_store_code_lookup_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:ecom_user_flutter/models/ecom/product/shop_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PreferredStoreCodeLookupPage
    extends GetView<PreferredStoreCodeLookupController> {
  const PreferredStoreCodeLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Find New Shop'),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter Shop Code',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => TextField(
                        controller: controller.codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '6 digit shop code',
                          prefixIcon: const Icon(Icons.pin_outlined),
                          suffixIcon: controller.code.value.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: controller.clearCode,
                                  icon: const Icon(Icons.close_rounded),
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 1.4,
                            ),
                          ),
                        ),
                        onSubmitted: (_) {
                          if (controller.canFind) controller.findShopByCode();
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => ElevatedButton.icon(
                        onPressed: controller.canFind
                            ? controller.findShopByCode
                            : null,
                        icon: controller.isFindingShop.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.search_rounded),
                        label: const Text('Find Shop'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: controller.goToScanner,
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: const Text('Scan Store QR'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return _ErrorBox(message: controller.errorMessage.value);
              }
              return const SizedBox.shrink();
            }),
            Obx(() {
              final shop = controller.foundShop.value;
              if (shop == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 14),
                child: _ShopProfileCard(shop: shop),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ShopProfileCard extends GetView<PreferredStoreCodeLookupController> {
  const _ShopProfileCard({required this.shop});

  final ShopProfile shop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final location = [
      shop.addressText,
      shop.districtText,
    ].where((value) => value != '-').join(', ');

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BannerImage(url: shop.bannerUrl),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LogoImage(url: shop.logoUrl),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop.displayName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _StatusChip(status: shop.status ?? 'active'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.confirmation_number_outlined,
                    text: shop.code ?? 'Code unavailable',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    text: shop.phoneText,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: location.isEmpty ? 'Address unavailable' : location,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    text: shop.sellerName,
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.isSettingActive.value
                            ? null
                            : controller.setFoundShopAsActive,
                        icon: controller.isSettingActive.value
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.storefront_rounded),
                        label: const Text('Set As Active Store'),
                      ),
                    ),
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

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final cleanUrl = url?.trim() ?? '';
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: Container(
        height: 130,
        color: AppColors.primaryColor.withOpacity(0.08),
        child: cleanUrl.isEmpty
            ? Icon(
                Icons.image_outlined,
                color: AppColors.primaryColor,
                size: 38,
              )
            : Image.network(
                cleanUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_outlined,
                  color: AppColors.primaryColor,
                  size: 38,
                ),
              ),
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final cleanUrl = url?.trim() ?? '';
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: cleanUrl.isEmpty
          ? Icon(
              Icons.storefront_rounded,
              color: AppColors.primaryColor,
              size: 30,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                cleanUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.storefront_rounded,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
            ),
    );
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
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
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
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF16A34A).withOpacity(0.12)
              : AppColors.textMuted.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status.capitalizeFirst ?? status,
          style: TextStyle(
            color: isActive ? const Color(0xFF15803D) : AppColors.textMuted,
            fontWeight: FontWeight.w900,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorColor.withOpacity(0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.errorColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.errorColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
