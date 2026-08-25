// lib/app/common/widgets/product_card.dart

import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/product_model.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/common/Color.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends GetWidget<ProductController> {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.width = 160,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final double width;

  String _formatMoney(num value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  bool _isPercentageDiscount(String? type) {
    final value = (type ?? '').toLowerCase().trim();

    return value.contains('percent') || value.contains('percentage');
  }

  num _discountedPrice({
    required num price,
    required double discount,
    required String? discountType,
  }) {
    if (discount <= 0) return price;

    final isPercentage = _isPercentageDiscount(discountType);

    final discountAmount = isPercentage ? price * discount / 100 : discount;

    final finalPrice = price - discountAmount;

    if (finalPrice < 0) return 0;

    return finalPrice;
  }

  String _discountText({
    required num discount,
    required String? discountType,
  }) {
    final isPercentage = _isPercentageDiscount(discountType);

    if (isPercentage) {
      return '${_formatMoney(discount)}%\nOFF';
    }

    return '৳${_formatMoney(discount)}\nOFF';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.primaryImage?.resolvedUrl(
      baseUrl: CompanyData.image_file_url,
    );

    final price = product.unitPrice;
    final discount = product.discount ?? 0;
    final hasDiscount = discount > 0;

    final finalPrice = _discountedPrice(
      price: price,
      discount: discount,
      discountType: product.discountType,
    );

    final name = (product.name ?? '').trim();
    final unit = (product.unit ?? '').trim();

    final rating = product.rating;
    final sold = product.numOfSale;

    final shopName = (product.shop?.name ?? product.addedBy ?? '').trim().isEmpty
        ? 'Shop Name'
        : (product.shop?.name ?? product.addedBy ?? '').trim();

    final isOutOfStock = product.currentStock <= 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap ??
            () {
              controller.getProductDetail(product.id);
            },
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.dividerColor.withOpacity(0.75),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image area
                Expanded(
                  flex: 52,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8),
                          child: imageUrl == null || imageUrl.isEmpty
                              ? const _ImagePlaceholder()
                              : Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) {
                                    return const _ImagePlaceholder();
                                  },
                                  loadingBuilder: (_, child, progress) {
                                    if (progress == null) return child;

                                    return const Center(
                                      child: SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      if (hasDiscount)
                        Positioned(
                          top: 0,
                          right: 8,
                          child: _DiscountRibbon(
                            text: _discountText(
                              discount: discount,
                              discountType: product.discountType,
                            ),
                          ),
                        ),
                      if (isOutOfStock) const _StockOutOverlay(),
                    ],
                  ),
                ),

                // Product info area
                Expanded(
                  flex: 48,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFF3F4F6),
                    padding: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'Product' : name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 10.5,
                            height: 1.12,
                          ),
                        ),
                        if (unit.isNotEmpty) ...[
                          const SizedBox(height: 1),
                          Text(
                            unit,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.primaryColor.withOpacity(0.72),
                              fontWeight: FontWeight.w700,
                              fontSize: 9,
                              height: 1.05,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                '৳${_formatMoney(finalPrice)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  height: 1,
                                ),
                              ),
                            ),
                            if (hasDiscount) ...[
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '৳${_formatMoney(price)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.42),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: AppColors.primaryColor
                                        .withOpacity(0.42),
                                    decorationThickness: 1.4,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: AppColors.golden,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _formatMoney(rating),
                              style: TextStyle(
                                color: AppColors.homeTextColor2,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Container(height: 10, width: 1, color: Colors.black,),
                            const SizedBox(width: 3),
                            Text(
                              '$sold sold',
                              style: TextStyle(
                                color: AppColors.homeTextColor2,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),


                          ],
                        ),
                        Flexible(
                          child: _ShopPill(text: shopName),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StockOutOverlay extends StatelessWidget {
  const _StockOutOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.white.withOpacity(0.58),
        alignment: Alignment.center,
        child: const _StockOutChip(),
      ),
    );
  }
}

class _StockOutChip extends StatelessWidget {
  const _StockOutChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE11D48),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Stock Out',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _DiscountRibbon extends StatelessWidget {
  const _DiscountRibbon({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _RibbonClipper(),
      child: Container(
        width: 34,
        height: 42,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 5),
        color: AppColors.primaryColor,
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: AppColors.golden,
            fontWeight: FontWeight.w900,
            fontSize: 8.5,
            height: 0.95,
          ),
        ),
      ),
    );
  }
}

class _RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, size.height - 7);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _ShopPill extends StatelessWidget {
  const _ShopPill({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 54,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.45),
          width: 0.7,
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 7.8,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 34,
          color: AppColors.primaryColor.withOpacity(0.35),
        ),
      ),
    );
  }
}
