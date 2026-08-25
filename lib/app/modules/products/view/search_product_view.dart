// lib/app/modules/products/view/product_filter_page.dart

import 'package:ecom_user_flutter/app/models/ecom/product/category_child_model.dart';
import 'package:ecom_user_flutter/app/models/ecom/product/category_model.dart';
import 'package:ecom_user_flutter/app/modules/products/controller/product_controller.dart';
import 'package:ecom_user_flutter/app/modules/products/view/widgets/product_card_widget.dart';
import 'package:ecom_user_flutter/common/Color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductFilterPage extends GetView<ProductController> {
  const ProductFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initProductFilterPage();
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _HeaderSearch(controller: controller),
            _FilterArea(controller: controller),
            _ResultHeader(controller: controller),
            Expanded(
              child: Obx(() {
                if (controller.isFilterLoading.value &&
                    controller.filterProducts.isEmpty) {
                  return const _ProductGridSkeleton();
                }

                if (controller.error.value.isNotEmpty &&
                    controller.filterProducts.isEmpty) {
                  return _ErrorState(
                    message: controller.error.value,
                    onRetry: () {
                      controller.getFilterProducts(reset: true);
                    },
                  );
                }

                if (controller.filterProducts.isEmpty) {
                  return const _EmptyState();
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.axis == Axis.vertical &&
                        notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 250) {
                      controller.loadMoreFilterProducts();
                    }

                    return false;
                  },
                  child: RefreshIndicator(
                    color: AppColors.primaryColor,
                    onRefresh: () async {
                      await controller.getFilterProducts(reset: true);
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: controller.filterProducts.length +
                          (controller.isFilterMoreLoading.value ? 1 : 0),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.58,
                      ),
                      itemBuilder: (context, index) {
                        if (index >= controller.filterProducts.length) {
                          return const Center(
                            child: SizedBox(
                              height: 26,
                              width: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }

                        return ProductCard(
                          product: controller.filterProducts[index],
                        );
                      },
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

class _HeaderSearch extends StatelessWidget {
  const _HeaderSearch({
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => Get.back(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.offerYellow,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'All Products',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                  ),
                ),
              ),
              Obx(() {
                return Text(
                  '${controller.filterTotal.value}',
                  style: TextStyle(
                    color: AppColors.offerYellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.searchCtrl.value,
            onChanged: controller.onSearchChanged,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: 'Search anything...',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.primaryColor,
              ),
              suffixIcon: Obx(() {
                final hasSearch = controller.search.value.trim().isNotEmpty;

                if (!hasSearch) {
                  return Icon(
                    Icons.tune_rounded,
                    color: AppColors.textMuted,
                  );
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    controller.clearSearch();
                    controller.getFilterProducts(reset: true);
                  },
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.textMuted,
                  ),
                );
              }),
              filled: true,
              fillColor: AppColors.backgroundColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterArea extends StatelessWidget {
  const _FilterArea({
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  final categories = controller.categories;

                  return _DropBox<CategoryItem>(
                    hint: 'Category',
                    value: controller.selectedCategory.value == null
                        ? null
                        : categories.firstWhereOrNull(
                          (item) =>
                      item.id == controller.selectedCategory.value,
                    ),
                    items: categories,
                    labelOf: (item) => (item.name ?? 'Category').trim(),
                    onChanged: (item) {
                      controller.setFilterCategory(item?.id);
                    },
                  );
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(() {
                  final subCategories = controller.categoryChilds;

                  return _DropBox<DatumCatChild>(
                    hint: controller.selectedCategory.value == null
                        ? 'Select category first'
                        : controller.isCategoryChildLoading.value
                        ? 'Loading...'
                        : 'Sub Category',
                    value: controller.selectedSubCategory.value == null
                        ? null
                        : subCategories.firstWhereOrNull(
                          (item) =>
                      item.id ==
                          controller.selectedSubCategory.value,
                    ),
                    items: subCategories,
                    labelOf: (item) => item.name.trim(),
                    enabled: controller.selectedCategory.value != null &&
                        !controller.isCategoryChildLoading.value,
                    onChanged: (item) {
                      controller.setFilterSubCategory(item?.id);
                    },
                  );
                }),
              ),
            ],
          ),
          Obx(() {
            final shouldShowChildCategory =
                controller.selectedSubCategory.value != null &&
                    (controller.isSubCategoryChildLoading.value ||
                        controller.subCategoryChilds.isNotEmpty);

            if (!shouldShowChildCategory) {
              return const SizedBox.shrink();
            }

            final childCategories = controller.subCategoryChilds;

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _DropBox<DatumCatChild>(
                hint: controller.isSubCategoryChildLoading.value
                    ? 'Loading...'
                    : 'Child Category',
                value: controller.selectedChildCategory.value == null
                    ? null
                    : childCategories.firstWhereOrNull(
                      (item) =>
                  item.id == controller.selectedChildCategory.value,
                ),
                items: childCategories,
                labelOf: (item) => item.name.trim(),
                enabled: !controller.isSubCategoryChildLoading.value &&
                    childCategories.isNotEmpty,
                onChanged: (item) {
                  controller.setFilterChildCategory(item?.id);
                },
              ),
            );
          }),
          const SizedBox(height: 10),
          Obx(() {
            final hasCategory = controller.selectedCategory.value != null;
            final hasSubCategory = controller.selectedSubCategory.value != null;
            final hasChildCategory =
                controller.selectedChildCategory.value != null;
            final hasSearch = controller.search.value.trim().isNotEmpty;

            if (!hasCategory &&
                !hasSubCategory &&
                !hasChildCategory &&
                !hasSearch) {
              return const SizedBox.shrink();
            }

            return Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (hasCategory)
                        _FilterChipButton(
                          label: 'Category selected',
                          onDeleted: controller.clearFilterCategory,
                        ),
                      if (hasSubCategory)
                        _FilterChipButton(
                          label: 'Sub-category selected',
                          onDeleted: controller.clearFilterSubCategory,
                        ),
                      if (hasChildCategory)
                        _FilterChipButton(
                          label: 'Child category selected',
                          onDeleted: controller.clearFilterChildCategory,
                        ),
                      if (hasSearch)
                        _FilterChipButton(
                          label: controller.search.value,
                          onDeleted: () {
                            controller.clearSearch();
                            controller.getFilterProducts(reset: true);
                          },
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: controller.clearFilterFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({
    required this.controller,
  });

  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBackground,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Products',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          Obx(() {
            return Text(
              '${controller.filterTotal.value} found',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DropBox<T> extends StatelessWidget {
  const _DropBox({
    required this.hint,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.enabled = true,
  });

  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final void Function(T?) onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: enabled
            ? AppColors.backgroundColor
            : AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.borderColor,
          width: 0.9,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: enabled ? value : null,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: enabled ? AppColors.primaryColor : AppColors.textMuted,
          ),
          hint: Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
          items: [
            DropdownMenuItem<T>(
              value: null,
              child: Text(
                'All',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            ...items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  labelOf(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              );
            }),
          ],
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.onDeleted,
  });

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDeleted,
            child: Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductGridSkeleton extends StatelessWidget {
  const _ProductGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.borderColor,
              width: 0.8,
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 56,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              'No products found',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try changing search, category, sub-category, or child category filter.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
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
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
