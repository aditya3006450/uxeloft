import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../controllers/shop_controller.dart';
import '../models/home_models.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

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
          'Product',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            final wished = ShopController.to.isWishlisted(product);
            return IconButton(
              onPressed: () => ShopController.to.toggleWishlist(product),
              icon: Icon(
                wished ? Icons.favorite : Icons.favorite_border,
                color: wished ? AppColors.accent : AppColors.primaryText,
              ),
            );
          }),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: product.image == null
                        ? Icon(
                            product.icon,
                            size: 120,
                            color: product.iconColor,
                          )
                        : Image.asset(
                            product.image!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Icon(
                              product.icon,
                              size: 120,
                              color: product.iconColor,
                            ),
                          ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        final filled = index < product.rating.round();
                        return Icon(
                          filled ? Icons.star : Icons.star_border,
                          size: 16,
                          color: AppColors.starYellow,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        '${product.rating}  ·  ${product.reviewCount} Reviews',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            _BottomBar(product: product),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Price',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const Spacer(),
          Obx(() {
            final inCart = ShopController.to.isInCart(product);
            if (!inCart) {
              return SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: () {
                    ShopController.to.addToCart(product);
                    Get.snackbar(
                      'Added to cart',
                      '${product.name} is in your cart',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }
            return Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => ShopController.to.decrement(product),
                    icon: const Icon(Icons.remove, color: Colors.white),
                  ),
                  Obx(() {
                    final line = ShopController.to.cart.firstWhere(
                      (item) => item.product.name == product.name,
                    );
                    return Text(
                      '${line.quantity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    );
                  }),
                  IconButton(
                    onPressed: () => ShopController.to.addToCart(product),
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
