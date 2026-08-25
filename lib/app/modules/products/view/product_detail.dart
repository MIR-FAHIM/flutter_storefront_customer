import 'package:ecom_user_flutter/app/api_providers/company_data.dart';
import 'package:ecom_user_flutter/app/modules/cart/controller/cart_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/product_card_widget.dart';
import 'package:ecom_user_flutter/app/routes/app_pages.dart';
import 'package:ecom_user_flutter/app/services/html_sanitizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class ProductDetailPage extends GetView<ProductController> {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dynamic product = controller.productDetail.value;

      if (controller.productDetailLoading.value && product == null) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.productDetailError.value.isNotEmpty && product == null) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _ErrorState(
            message: controller.productDetailError.value,
          ),
        );
      }

      if (product == null) {
        return const Scaffold(
          backgroundColor: Colors.white,
          body: _EmptyState(),
        );
      }

      final images = _ProductDetailHelper._productImages(product);
      final title = _ProductDetailHelper._productTitle(product);
      final description = _ProductDetailHelper._productDescription(product);
      final productId = _ProductDetailHelper._productId(product);
      final maxStock = _ProductDetailHelper._productStock(product);
      final isOutOfStock = maxStock <= 0;
      final unitPriceValue = _ProductDetailHelper._productFinalUnitPriceValue(product);

      return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _BottomActionBar(
          controller: controller,
          productId: productId,
          maxStock: maxStock,
          unitPriceValue: unitPriceValue,
          isOutOfStock: isOutOfStock,
        ),
        body: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _ProductImageHeader(
                images: images,
                title: title,
                isOutOfStock: isOutOfStock,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProductTitle(title: title),
                    const SizedBox(height: 8),
                    _RatingSoldRow(product: product),
                    const SizedBox(height: 8),
                    _PriceRow(product: product),
                    if (isOutOfStock) ...[
                      const SizedBox(height: 10),
                      const _StockOutNotice(),
                    ],
                    const SizedBox(height: 10),
                    _SellerCard(product: product),
                    const SizedBox(height: 12),
                    _QuantityRow(
                      controller: controller,
                      maxStock: maxStock,
                      isOutOfStock: isOutOfStock,
                    ),
                    const SizedBox(height: 10),
                    _TotalPriceBlock(
                      controller: controller,
                      unitPriceValue: unitPriceValue,
                      fallbackPriceText: _ProductDetailHelper._currentPriceText(product),
                    ),
                    const SizedBox(height: 12),
                    _DescriptionBlock(
                      title: title,
                      description: description,
                    ),
                    const SizedBox(height: 12),
                    _SmartInfoRows(product: product),
                    const SizedBox(height: 14),
                    _RelatedProductsSection(
                      title: "Product you may also like",
                      currentProductId: productId,
                      products: controller.products,
                    ),
                    const SizedBox(height: 14),
                    _TopSellingSection(
                      currentProductId: productId,
                      products: controller.products,
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }


}

class _ProductDetailHelper {
  static dynamic _tryRead(dynamic Function() reader) {
    try {
      return reader();
    } catch (_) {
      return null;
    }
  }

  static dynamic _firstValue(List<dynamic Function()> readers) {
    for (final reader in readers) {
      final value = _tryRead(reader);

      if (value == null) continue;

      final text = value.toString().trim();

      if (text.isEmpty || text.toLowerCase() == 'null') continue;

      return value;
    }

    return null;
  }

  static String _clean(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;

    final text = value.toString().trim();

    if (text.isEmpty || text.toLowerCase() == 'null') {
      return fallback;
    }

    if (text.startsWith('Instance of')) {
      return fallback;
    }

    return text;
  }

  static String _productId(dynamic product) {
    return _clean(
      _firstValue([
            () => product.id,
            () => product.productId,
            () => product['id'],
            () => product['product_id'],
      ]),
    );
  }

  static String _productTitle(dynamic product) {
    return _clean(
      _firstValue([
            () => product.name,
            () => product.title,
            () => product.productName,
            () => product['name'],
            () => product['title'],
            () => product['product_name'],
      ]),
      fallback: 'Product Details',
    );
  }

  static String _productDescription(dynamic product) {
    final raw = _clean(
      _firstValue([
            () => product.description,
            () => product.shortDescription,
            () => product.details,
            () => product['description'],
            () => product['short_description'],
            () => product['details'],
      ]),
    );

    if (raw.isEmpty) {
      return '<p>No description available.</p>';
    }

    return raw;
  }

  static String _currentPriceText(dynamic product) {
    final finalPrice = _productFinalUnitPriceValue(product);

    if (finalPrice > 0) {
      return _formatMoney(finalPrice);
    }

    final value = _firstValue([
          () => product.mainPrice,
          () => product.price,
          () => product.basePrice,
          () => product['main_price'],
          () => product['price'],
          () => product['base_price'],
    ]);

    return _money(value);
  }

  static double _productUnitPriceValue(dynamic product) {
    final value = _firstValue([
          () => product.unitPrice,
          () => product.price,
          () => product.basePrice,
          () => product.mainPrice,
          () => product['unit_price'],
          () => product['price'],
          () => product['base_price'],
          () => product['main_price'],
    ]);

    return _toDouble(value);
  }

  static int _productStock(dynamic product) {
    final value = _firstValue([
          () => product.currentStock,
          () => product.stock,
          () => product.quantity,
          () => product.qty,
          () => product['current_stock'],
          () => product['stock'],
          () => product['quantity'],
          () => product['qty'],
    ]);

    final raw = _clean(value);
    if (raw.isEmpty) return 100;

    final parsed = double.tryParse(
      raw.replaceAll(RegExp(r'[^0-9.-]'), ''),
    )?.floor();

    if (parsed == null) return 100;
    if (parsed < 0) return 0;

    return parsed;
  }

  static String _oldPriceText(dynamic product) {
    final unitPrice = _productUnitPriceValue(product);

    if (_hasDiscount(product) && unitPrice > 0) {
      return _formatMoney(unitPrice);
    }

    final value = _firstValue([
          () => product.strokedPrice,
          () => product.oldPrice,
          () => product.purchasePrice,
          () => product.regularPrice,
          () => product['stroked_price'],
          () => product['old_price'],
          () => product['purchase_price'],
          () => product['regular_price'],
    ]);

    return _money(value, allowEmpty: true);
  }

  static String _discountText(dynamic product) {
    final direct = _clean(
      _firstValue([
            () => product.discountText,
            () => product.discountLabel,
            () => product['discount_text'],
            () => product['discount_label'],
      ]),
    );

    if (direct.isNotEmpty) return direct;

    final discount = _productDiscountValue(product);
    if (discount <= 0) return '';

    final type = _productDiscountType(product).toLowerCase();
    final isPercent = type.contains('percent') || type == '%';

    if (isPercent) {
      final clean = discount % 1 == 0
          ? discount.toInt().toString()
          : discount.toStringAsFixed(2);

      return '$clean% OFF';
    }

    return '${_formatMoney(discount)} OFF';
  }

  static double _productFinalUnitPriceValue(dynamic product) {
    final unitPrice = _productUnitPriceValue(product);
    final discount = _productDiscountValue(product);

    if (unitPrice <= 0 || discount <= 0) return unitPrice;

    final type = _productDiscountType(product).toLowerCase();
    final isPercent = type.contains('percent') || type == '%';

    final calculated = isPercent
        ? unitPrice - ((unitPrice * discount) / 100)
        : unitPrice - discount;

    if (calculated < 0) return 0;

    return calculated;
  }

  static bool _hasDiscount(dynamic product) {
    return _productDiscountValue(product) > 0;
  }

  static double _productDiscountValue(dynamic product) {
    final value = _firstValue([
          () => product.discount,
          () => product.discountAmount,
          () => product['discount'],
          () => product['discount_amount'],
    ]);

    return _toDouble(value);
  }

  static String _productDiscountType(dynamic product) {
    return _clean(
      _firstValue([
            () => product.discountType,
            () => product['discount_type'],
      ]),
    );
  }

  static List<String> _productImages(dynamic product) {
    final images = <String>[];

    void addImage(dynamic value) {
      final url = _asImageUrl(value);

      if (url.isEmpty) return;
      if (!images.contains(url)) images.add(url);
    }

    addImage(
      _firstValue([
            () => product.primaryImage?.url,
            () => product.primaryImage?.fileName,
            () => product.primaryImage?.resolvedUrl(
          baseUrl: CompanyData.image_file_url,
        ),
            () => product.thumbnailImage?.url,
            () => product.thumbnailImage?.fileName,
            () => product.image,
            () => product.thumbnail,
            () => product.photo,
            () => product['primary_image']?['url'],
            () => product['primary_image']?['file_name'],
            () => product['primary_image']?['resolved_url'],
            () => product['thumbnail_image']?['url'],
            () => product['thumbnail_image']?['file_name'],
            () => product['thumbnail_image']?['resolved_url'],
            () => product['image'],
            () => product['thumbnail'],
            () => product['photo'],
      ]),
    );

    final gallery = _tryRead(() => product.images);

    if (gallery is Iterable) {
      for (final item in gallery) {
        addImage(
          _firstValue([
                () => item.url,
                () => item.fileName,
                () => item.resolvedUrl(baseUrl: CompanyData.image_file_url),
                () => item['url'],
                () => item['file_name'],
                () => item['resolved_url'],
          ]),
        );
      }
    }

    return images;
  }

  static String _asImageUrl(dynamic value) {
    final raw = _clean(value);

    if (raw.isEmpty) return '';

    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }

    final base = CompanyData.image_file_url.endsWith('/')
        ? CompanyData.image_file_url.substring(
      0,
      CompanyData.image_file_url.length - 1,
    )
        : CompanyData.image_file_url;

    final path = raw.startsWith('/') ? raw.substring(1) : raw;

    return '$base/$path';
  }

  static String _money(dynamic value, {bool allowEmpty = false}) {
    final raw = _clean(value);

    if (raw.isEmpty) return allowEmpty ? '' : '৳ 0';

    if (raw.contains('৳') ||
        raw.toLowerCase().contains('tk') ||
        raw.toLowerCase().contains('bdt')) {
      return raw;
    }

    return '৳ $raw';
  }

  static double _toDouble(dynamic value) {
    final raw = _clean(value);

    if (raw.isEmpty) return 0;

    final cleaned = raw.replaceAll(',', '').replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  static String _formatMoney(double value) {
    if (value <= 0) return '৳ 0';

    if (value % 1 == 0) {
      return '৳ ${value.toInt()}';
    }

    return '৳ ${value.toStringAsFixed(2)}';
  }

  static String _stripHtml(String value) {
    return value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}


class _ProductImageHeader extends StatefulWidget {
  const _ProductImageHeader({
    required this.images,
    required this.title,
    required this.isOutOfStock,
  });

  final List<String> images;
  final String title;
  final bool isOutOfStock;

  @override
  State<_ProductImageHeader> createState() => _ProductImageHeaderState();
}

class _ProductImageHeaderState extends State<_ProductImageHeader> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const Color _primary = Color(0xFF00509D);
  static const Color _yellow = Color(0xFFFEFF00);

  @override
  void didUpdateWidget(covariant _ProductImageHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.images != widget.images) {
      _currentIndex = 0;

      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            top: 64,
            child: widget.images.isEmpty
                ? const _ImagePlaceholder()
                : PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final imageUrl = widget.images[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 34,
                    vertical: 8,
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;

                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) {
                      return const _ImagePlaceholder();
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 14,
            top: 12,
            right: 14,
            child: Row(
              children: [
                _TopIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  iconColor: _yellow,
                  backgroundColor: _primary,
                  onTap: () => Get.back(),
                ),
                const Spacer(),
                const _CartTopIconButton(),
                const SizedBox(width: 8),
                _TopIconButton(
                  icon: Icons.share_rounded,
                  iconColor: _primary,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                _TopIconButton(
                  icon: Icons.favorite_rounded,
                  iconColor: _primary,
                  showDot: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: _DotsIndicator(
              count: widget.images.isEmpty ? 1 : widget.images.length,
              currentIndex: _currentIndex,
            ),
          ),
          if (widget.isOutOfStock)
            Positioned(
              left: 24,
              right: 24,
              bottom: 54,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE11D48),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'Stock Out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CartTopIconButton extends StatelessWidget {
  const _CartTopIconButton();

  static const Color _primary = Color(0xFF00509D);
  static const Color _yellow = Color(0xFFFEFF00);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Obx(() {
      final count = cartController.cart.value?.totalItems ?? 0;

      return Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Get.toNamed(Routes.CART_VIEW);
          },
          child: SizedBox(
            height: 36,
            width: 36,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  color: _primary,
                  size: 22,
                ),
                if (count > 0)
                  Positioned(
                    right: -2,
                    top: -4,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: _yellow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _primary,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: const TextStyle(
                          color: _primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 9,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = const Color(0xFF00509D),
    this.backgroundColor = Colors.white,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color backgroundColor;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 36,
          width: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
              if (showDot)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    height: 7,
                    width: 7,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEFF00),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: iconColor,
                        width: 0.8,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count > 5 ? 5 : count,
            (index) {
          final active = index == currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 7,
            width: active ? 8 : 7,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF00509D) : const Color(0xFFB8CEE3),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}

class _ProductTitle extends StatelessWidget {
  const _ProductTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF00509D),
        fontWeight: FontWeight.w900,
        fontSize: 19,
        height: 1.15,
      ),
    );
  }
}

class _RatingSoldRow extends StatelessWidget {
  const _RatingSoldRow({
    required this.product,
  });

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    final rating = _ProductDetailHelper._toDouble(
      _ProductDetailHelper._firstValue([
            () => product.rating,
            () => product.averageRating,
            () => product.avgRating,
            () => product['rating'],
            () => product['average_rating'],
      ]),
    );

    final reviewCount = _ProductDetailHelper._clean(
      _ProductDetailHelper._firstValue([
            () => product.reviewCount,
            () => product.reviewsCount,
            () => product.reviews,
            () => product['review_count'],
            () => product['reviews_count'],
      ]),
      fallback: '0',
    );

    final soldCount = _ProductDetailHelper._clean(
      _ProductDetailHelper._firstValue([
            () => product.numOfSale,
            () => product.sold,
            () => product.totalSold,
            () => product['num_of_sale'],
            () => product['sold'],
            () => product['total_sold'],
      ]),
      fallback: '0',
    );

    return Row(
      children: [
        ...List.generate(
          5,
              (index) {
            return Icon(
              index < rating.round() ? Icons.star_rounded : Icons.star_rounded,
              size: 15,
              color: index < rating.round()
                  ? const Color(0xFFFFC107)
                  : Colors.grey.shade300,
            );
          },
        ),
        const SizedBox(width: 4),
        Text(
          "($reviewCount)",
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 1,
          height: 13,
          color: const Color(0xFFE5E7EB),
        ),
        const SizedBox(width: 8),
        Text(
          "$soldCount sold",
          style: const TextStyle(
            color: Color(0xFF00509D),
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.product,
  });

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    final currentPrice = _ProductDetailHelper._currentPriceText(product);
    final oldPrice = _ProductDetailHelper._oldPriceText(product);
    final discount = _ProductDetailHelper._discountText(product);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          currentPrice,
          style: const TextStyle(
            color: Color(0xFF00509D),
            fontWeight: FontWeight.w900,
            fontSize: 28,
            height: 1,
          ),
        ),
        if (oldPrice.isNotEmpty) ...[
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              oldPrice,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w800,
                fontSize: 17,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
        if (discount.isNotEmpty) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                discount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SellerCard extends StatelessWidget {
  const _SellerCard({
    required this.product,
  });

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    final sellerName = _ProductDetailHelper._clean(
      _ProductDetailHelper._firstValue([
            () => product.shop?.shopName,
            () => product.seller?.name,
            () => product.addedBy,
            () => product.sellerName,
            () => product['shop']?['name'],
            () => product['seller']?['name'],
            () => product['added_by'],
            () => product['seller_name'],
      ]),
      fallback: 'Color Crush',
    );

    final sellerImage = _ProductDetailHelper._clean(
      _ProductDetailHelper._firstValue([
            () => product.shop?.logo?.resolvedUrl,
            () => product.shop?.logo?.url,
            () => product.seller?.avatar,
            () => product['shop']?['logo']?['resolved_url'],
            () => product['shop']?['logo']?['url'],
      ]),
    );

    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB8CEE3),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: sellerImage.isEmpty
                ? const Icon(
              Icons.storefront_rounded,
              color: Color(0xFF00509D),
              size: 22,
            )
                : Image.network(
              sellerImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.storefront_rounded,
                  color: Color(0xFF00509D),
                  size: 22,
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Manufacturer",
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sellerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF00509D),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}

class _StockOutNotice extends StatelessWidget {
  const _StockOutNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEF2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE11D48).withOpacity(0.22)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFE11D48),
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'This product is currently stock out.',
              style: TextStyle(
                color: Color(0xFFE11D48),
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityRow extends StatelessWidget {
  const _QuantityRow({
    required this.controller,
    required this.maxStock,
    required this.isOutOfStock,
  });

  final ProductController controller;
  final int maxStock;
  final bool isOutOfStock;

  @override
  Widget build(BuildContext context) {

    if(isOutOfStock == true){

      return Row(
        children: [
          const Text(
            "Quantity",
            style: TextStyle(
              color: Color(0xFF00509D),
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 20),
          _QtyButton(
            icon: Icons.remove_rounded,
            onTap: isOutOfStock ? null : controller.decreaseQty,
          ),
          const SizedBox(width: 14),
          Text(
            isOutOfStock ? '0' : controller.quantity.value.toString(),
            style: TextStyle(
              color: isOutOfStock
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF00509D),
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
          const SizedBox(width: 14),
          _QtyButton(
            icon: Icons.add_rounded,
            onTap: isOutOfStock
                ? null
                : () {
              controller.increaseQty(maxStock: maxStock);
            },
          ),
          const SizedBox(width: 14),
          Text(
            isOutOfStock ? '(Stock Out)' : "($maxStock)",
            style: TextStyle(
              color: isOutOfStock
                  ? const Color(0xFFE11D48)
                  : const Color(0xFF7B8DA3),
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      );

    }else{
      return Obx(() {
        return Row(
          children: [
            const Text(
              "Quantity",
              style: TextStyle(
                color: Color(0xFF00509D),
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 20),
            _QtyButton(
              icon: Icons.remove_rounded,
              onTap: isOutOfStock ? null : controller.decreaseQty,
            ),
            const SizedBox(width: 14),
            Text(
              isOutOfStock ? '0' : controller.quantity.value.toString(),
              style: TextStyle(
                color: isOutOfStock
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF00509D),
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
            const SizedBox(width: 14),
            _QtyButton(
              icon: Icons.add_rounded,
              onTap: isOutOfStock
                  ? null
                  : () {
                controller.increaseQty(maxStock: maxStock);
              },
            ),
            const SizedBox(width: 14),
            Text(
              isOutOfStock ? '(Stock Out)' : "($maxStock)",
              style: TextStyle(
                color: isOutOfStock
                    ? const Color(0xFFE11D48)
                    : const Color(0xFF7B8DA3),
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        );
      });
    }

  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        height: 26,
        width: 26,
        child: Icon(
          icon,
          color: enabled ? const Color(0xFF00509D) : const Color(0xFF9CA3AF),
          size: 20,
        ),
      ),
    );
  }
}

class _TotalPriceBlock extends StatelessWidget {
  const _TotalPriceBlock({
    required this.controller,
    required this.unitPriceValue,
    required this.fallbackPriceText,
  });

  final ProductController controller;
  final double unitPriceValue;
  final String fallbackPriceText;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final qty = controller.quantity.value;
      final total = unitPriceValue > 0
          ? _ProductDetailHelper._formatMoney(unitPriceValue * qty)
          : fallbackPriceText;

      return Container(
        height: 56,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: const BoxDecoration(
          color: Color(0xFFB8CEE3),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Total Price",
                style: TextStyle(
                  color: Color(0xFF00509D),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              total,
              style: const TextStyle(
                color: Color(0xFF00509D),
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DescriptionBlock extends StatefulWidget {
  const _DescriptionBlock({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  State<_DescriptionBlock> createState() =>
      _DescriptionBlockState();
}

class _DescriptionBlockState
    extends State<_DescriptionBlock> {
  static const Color _primary = Color(0xFF00509D);
  static const Color _border = Color(0xFFE5E7EB);
  static const Color _background = Color(0xFFF8FAFC);

  static const double _collapsedHeight = 190;

  bool _isExpanded = false;

  String get _safeHtml {
    final normalised = _normaliseHtml(
      widget.description,
    );

    return ProductHtmlSanitizer.sanitize(
      normalised,
    );
  }

  String get _plainText {
    try {
      return html_parser
          .parse(_safeHtml)
          .body
          ?.text
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim() ??
          '';
    } catch (_) {
      return '';
    }
  }

  bool get _hasDescription {
    final value = _plainText.toLowerCase();

    return value.isNotEmpty &&
        value != 'null' &&
        value != 'no description available.';
  }

  bool get _shouldShowToggle {
    final html = _safeHtml.toLowerCase();

    return _plainText.length > 220 ||
        html.contains('<img') ||
        html.contains('<table') ||
        html.contains('<ul') ||
        html.contains('<ol') ||
        html.contains('<h1') ||
        html.contains('<h2') ||
        html.contains('<h3');
  }

  @override
  void didUpdateWidget(
      covariant _DescriptionBlock oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.description != widget.description) {
      _isExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasDescription) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const Divider(
            height: 1,
            thickness: 1,
            color: _border,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              10,
              14,
              0,
            ),
            child: AnimatedSize(
              duration: const Duration(
                milliseconds: 280,
              ),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _buildDescriptionContent(),
            ),
          ),

          if (_shouldShowToggle)
            _buildToggleButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      color: _background,
      child: const Row(
        children: [
          _DescriptionIcon(),

          SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Description',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Details, specifications and features',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionContent() {
    if (_isExpanded || !_shouldShowToggle) {
      return _buildHtml();
    }

    return SizedBox(
      height: _collapsedHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: SingleChildScrollView(
                physics:
                const NeverScrollableScrollPhysics(),
                child: _buildHtml(),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                height: 65,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00FFFFFF),
                      Color(0xD9FFFFFF),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHtml() {
    return Html(
      data: _safeHtml,
      shrinkWrap: true,
      style: {
        'html': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          color: const Color(0xFF334155),
          fontSize: FontSize(13),
          lineHeight: const LineHeight(1.55),
        ),
        'p': Style(
          margin: Margins.only(
            top: 0,
            bottom: 10,
          ),
          padding: HtmlPaddings.zero,
        ),
        'h1': Style(
          margin: Margins.only(
            top: 8,
            bottom: 8,
          ),
        ),
        'h2': Style(
          margin: Margins.only(
            top: 8,
            bottom: 8,
          ),
        ),
        'h3': Style(
          margin: Margins.only(
            top: 7,
            bottom: 7,
          ),
        ),
        'h4': Style(
          margin: Margins.only(
            top: 6,
            bottom: 6,
          ),
        ),
        'ul': Style(
          margin: Margins.only(
            top: 4,
            bottom: 10,
            left: 18,
          ),
          padding: HtmlPaddings.zero,
        ),
        'ol': Style(
          margin: Margins.only(
            top: 4,
            bottom: 10,
            left: 18,
          ),
          padding: HtmlPaddings.zero,
        ),
        'li': Style(
          margin: Margins.only(
            bottom: 5,
          ),
          lineHeight: const LineHeight(1.45),
        ),
        'img': Style(
          width: Width(
            100,
            Unit.percent,
          ),
          height: Height.auto(),
          margin: Margins.symmetric(
            vertical: 10,
          ),
        ),
        'table': Style(
          width: Width(
            100,
            Unit.percent,
          ),
          margin: Margins.symmetric(
            vertical: 10,
          ),
        ),
        'th': Style(
          padding: HtmlPaddings.all(8),
          backgroundColor:
          const Color(0xFFEAF2FA),
        ),
        'td': Style(
          padding: HtmlPaddings.all(8),
        ),
        'blockquote': Style(
          margin: Margins.symmetric(
            vertical: 8,
          ),
          padding: HtmlPaddings.only(
            left: 12,
            top: 8,
            right: 8,
            bottom: 8,
          ),
          backgroundColor:
          const Color(0xFFF1F5F9),
          border: const Border(
            left: BorderSide(
              color: _primary,
              width: 3,
            ),
          ),
        ),
        'a': Style(
          color: _primary,
          textDecoration:
          TextDecoration.underline,
        ),
      },
      onLinkTap: (
          url,
          attributes,
          element,
          ) {
        debugPrint(
          'Description link tapped: $url',
        );
      },
    );
  }

  Widget _buildToggleButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        4,
        14,
        12,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.08),
                borderRadius:
                BorderRadius.circular(30),
                border: Border.all(
                  color:
                  _primary.withOpacity(0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded
                        ? 'Show Less'
                        : 'View Full Description',
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(width: 5),

                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(
                      milliseconds: 220,
                    ),
                    child: const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      color: _primary,
                      size: 19,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _normaliseHtml(String value) {
    var html = value.trim();

    if (html.isEmpty ||
        html.toLowerCase() == 'null') {
      return '';
    }

    html = html
        .replaceAll(r'\r\n', '\n')
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\t', '\t')
        .replaceAll(r'\"', '"')
        .replaceAll(r"\'", "'");

    return html;
  }
}

class _DescriptionIcon extends StatelessWidget {
  const _DescriptionIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF00509D)
            .withOpacity(0.10),
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Icon(
        Icons.description_outlined,
        color: Color(0xFF00509D),
        size: 21,
      ),
    );
  }
}

class _SmartInfoRows extends StatelessWidget {
  const _SmartInfoRows({
    required this.product,
  });

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SmartInfoTile(
          title: "Video",
          child: _SimpleInfoText(
            text: _ProductDetailHelper._clean(
              _ProductDetailHelper._firstValue([
                    () => product.videoLink,
                    () => product.video,
                    () => product['video_link'],
                    () => product['video'],
              ]),
              fallback: 'No video available for this product.',
            ),
          ),
        ),
        _SmartInfoTile(
          title: "Reviews",
          child: const _SimpleInfoText(
            text: 'Customer reviews will appear here.',
          ),
        ),
        _SmartInfoTile(
          title: "Seller Policy",
          child: const _SimpleInfoText(
            text: 'Seller policy information will appear here.',
          ),
        ),
        _SmartInfoTile(
          title: "Return Policy",
          child: const _SimpleInfoText(
            text: 'Return policy information will appear here.',
          ),
        ),
        _SmartInfoTile(
          title: "Support Policy",
          child: const _SimpleInfoText(
            text: 'Support policy information will appear here.',
          ),
        ),
      ],
    );
  }
}

class _SmartInfoTile extends StatelessWidget {
  const _SmartInfoTile({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: const BoxDecoration(
        color: Color(0xFFB8CEE3),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          collapsedIconColor: const Color(0xFF00509D),
          iconColor: const Color(0xFF00509D),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF00509D),
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          trailing: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFFFEFF00),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00509D),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 11,
              color: Color(0xFF00509D),
            ),
          ),
          children: [
            child,
          ],
        ),
      ),
    );
  }
}

class _SimpleInfoText extends StatelessWidget {
  const _SimpleInfoText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF00509D),
          fontWeight: FontWeight.w600,
          fontSize: 12,
          height: 1.35,
        ),
      ),
    );
  }
}

class _RelatedProductsSection extends StatelessWidget {
  const _RelatedProductsSection({
    required this.title,
    required this.currentProductId,
    required this.products,
  });

  final String title;
  final String currentProductId;
  final List products;

  @override
  Widget build(BuildContext context) {
    final filtered = products
        .where((item) {
      final dynamic product = item;
      final id = _ProductDetailHelper._clean(
        _ProductDetailHelper._firstValue([
              () => product.id,
              () => product.productId,
              () => product['id'],
              () => product['product_id'],
        ]),
      );

      return id != currentProductId;
    })
        .take(8)
        .toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title),
        const SizedBox(height: 8),
        SizedBox(
          height: 186,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return ProductCard(
                product: filtered[index],
                width: 112,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TopSellingSection extends StatelessWidget {
  const _TopSellingSection({
    required this.currentProductId,
    required this.products,
  });

  final String currentProductId;
  final List products;

  @override
  Widget build(BuildContext context) {
    final filtered = products
        .where((item) {
      final dynamic product = item;
      final id = _ProductDetailHelper._clean(
        _ProductDetailHelper._firstValue([
              () => product.id,
              () => product.productId,
              () => product['id'],
              () => product['product_id'],
        ]),
      );

      return id != currentProductId;
    })
        .take(5)
        .toList();

    if (filtered.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: "Top selling Product"),
        const SizedBox(height: 8),
        ListView.separated(
          itemCount: filtered.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _TopSellingCard(product: filtered[index]);
          },
        ),
      ],
    );
  }
}

class _TopSellingCard extends StatelessWidget {
  const _TopSellingCard({
    required this.product,
  });

  final dynamic product;

  @override
  Widget build(BuildContext context) {
    final title = _ProductDetailHelper._productTitle(product);
    final price = _ProductDetailHelper._currentPriceText(product);
    final oldPrice = _ProductDetailHelper._oldPriceText(product);
    final discount = _ProductDetailHelper._discountText(product);
    final images = _ProductDetailHelper._productImages(product);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        final id = _ProductDetailHelper._productId(product);

        if (id.isNotEmpty) {
          final productId = int.tryParse(id);
          if (productId != null) {
            Get.find<ProductController>().getProductDetail(productId);
          }
        }
      },
      child: Container(
        height: 78,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: images.isEmpty
                  ? const _ImagePlaceholder()
                  : Image.network(
                images.first,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const _ImagePlaceholder();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF00509D),
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: Color(0xFF00509D),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          height: 1,
                        ),
                      ),
                      if (oldPrice.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          oldPrice,
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      if (discount.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            discount,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:  TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ],
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF00509D),
        fontWeight: FontWeight.w900,
        fontSize: 16,
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.controller,
    required this.productId,
    required this.maxStock,
    required this.unitPriceValue,
    required this.isOutOfStock,
  });

  final ProductController controller;
  final String productId;
  final int maxStock;
  final double unitPriceValue;
  final bool isOutOfStock;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Get.toNamed(Routes.CART_VIEW);
              },
              child: Container(
                height: 48,
                width: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF00509D),
                    ),
                    Obx(() {
                      final count =
                          Get.find<CartController>().cart.value?.totalItems ??
                              0;

                      if (count <= 0) return const SizedBox.shrink();

                      return Positioned(
                        right: 7,
                        top: 6,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEFF00),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF00509D),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            count > 99 ? '99+' : count.toString(),
                            style: const TextStyle(
                              color: Color(0xFF00509D),
                              fontWeight: FontWeight.w900,
                              fontSize: 8,
                              height: 1,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                return ElevatedButton(
                  onPressed: controller.isCartLoading.value || isOutOfStock
                      ? null
                      : () {
                    if (productId.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Product ID not found',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    controller.addToCart(
                      productId: productId,
                      qty: controller.quantity.value,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOutOfStock
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF00509D),
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: const Color(0xFF64748B),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: controller.isCartLoading.value
                      ? const SizedBox(
                    height: 19,
                    width: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    isOutOfStock ? "Stock Out" : "Add To Cart",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                );
              }),
            ),
          ],
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
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        color: const Color(0xFF00509D).withOpacity(0.35),
        size: 54,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Product details not found",
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF151738),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
