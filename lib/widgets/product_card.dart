import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/home_models.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _wishlisted = false;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => _wishlisted = !_wishlisted),
                borderRadius: BorderRadius.circular(20),
                child: Icon(
                  _wishlisted ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: _wishlisted
                      ? AppColors.accent
                      : AppColors.secondaryText,
                ),
              ),
              const _MoreMenu(),
            ],
          ),
          Expanded(
            child: Center(
              child: product.image == null
                  ? Icon(product.icon, size: 62, color: product.iconColor)
                  : Image.asset(
                      product.image!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        product.icon,
                        size: 62,
                        color: product.iconColor,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              _AddButton(
                added: _added,
                onTap: () {
                  setState(() => _added = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) setState(() => _added = false);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star, size: 13, color: AppColors.starYellow),
              const SizedBox(width: 3),
              Text(
                product.rating.toString(),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${product.reviewCount} Reviews',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.added, required this.onTap});

  final bool added;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              added ? Icons.check : Icons.shopping_cart_outlined,
              size: 13,
              color: AppColors.background,
            ),
            const SizedBox(width: 3),
            Text(
              added ? 'Added' : 'Add',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.background,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreMenu extends StatelessWidget {
  const _MoreMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      iconSize: 18,
      splashRadius: 16,
      tooltip: '',
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (value) {},
      itemBuilder: (context) => const [
        PopupMenuItem(
          height: 38,
          value: 'details',
          child: Text('View Details', style: TextStyle(fontSize: 12)),
        ),
        PopupMenuItem(
          height: 38,
          value: 'wishlist',
          child: Text('Add to Wishlist', style: TextStyle(fontSize: 12)),
        ),
        PopupMenuItem(
          height: 38,
          value: 'share',
          child: Text('Share', style: TextStyle(fontSize: 12)),
        ),
      ],
      child: const Icon(
        Icons.more_vert,
        size: 18,
        color: AppColors.secondaryText,
      ),
    );
  }
}

