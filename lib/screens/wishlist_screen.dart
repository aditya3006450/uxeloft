import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../controllers/shop_controller.dart';
import '../models/home_models.dart';
import '../widgets/product_tile.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        final items = ShopController.to.wishlist;
        if (items.isEmpty) {
          return const _EmptyWishlist();
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: AppColors.divider,
          ),
          itemBuilder: (context, index) {
            final product = items[index];
            return Dismissible(
              key: ValueKey(product.name),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => ShopController.to.toggleWishlist(product),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                color: AppColors.accent,
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              child: ProductTile(
                product: product,
                onTap: () =>
                    Get.to(() => ProductDetailScreen(product: product)),
              ),
            );
          },
        );
      }),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 64,
            color: AppColors.inactiveIcon,
          ),
          const SizedBox(height: 16),
          const Text(
            'Wishlist is empty',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap the heart on any product to save it here.',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Get.back(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Browse products'),
          ),
        ],
      ),
    );
  }
}
