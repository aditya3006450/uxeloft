import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../data/shop_data.dart';
import '../widgets/product_tile.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final products = ShopData.byCategory(category);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        scrolledUnderIconTheme: const IconThemeData(color: AppColors.primaryText),
        title: Text(
          category,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: AppColors.inactiveIcon,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No products found in this category.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => Get.back(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Browse all products'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: products.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: AppColors.divider,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductTile(
                  product: product,
                  onTap: () => Get.to(
                    () => ProductDetailScreen(product: product),
                  ),
                );
              },
            ),
    );
  }
}