import 'package:flutter/material.dart';

import '../models/home_models.dart';

class ShopData {
  static const List<CategoryItem> categories = [
    CategoryItem(
      name: 'Beauty',
      icon: Icons.face_retouching_natural,
      iconColor: Color(0xFFE56BA0),
      image: 'assets/categories/beauty.png',
    ),
    CategoryItem(
      name: 'Offers',
      icon: Icons.local_offer,
      iconColor: Color(0xFFE53935),
      image: 'assets/categories/offers.png',
    ),
    CategoryItem(
      name: 'Fashion',
      icon: Icons.woman,
      iconColor: Color(0xFF8E5BD0),
      image: 'assets/categories/fashion.png',
    ),
    CategoryItem(
      name: 'Home',
      icon: Icons.weekend,
      iconColor: Color(0xFFB07A45),
      image: 'assets/categories/home.png',
    ),
    CategoryItem(
      name: 'Shirt',
      icon: Icons.checkroom,
      iconColor: Color(0xFF4A90D9),
      image: 'assets/categories/shirt.png',
    ),
    CategoryItem(
      name: 'Woman Bag',
      icon: Icons.shopping_bag,
      iconColor: Color(0xFFC9873F),
      image: 'assets/categories/woman_bag.png',
    ),
    CategoryItem(
      name: 'Dress',
      icon: Icons.dry_cleaning,
      iconColor: Color(0xFFE08A1E),
      image: 'assets/categories/dress.png',
    ),
    CategoryItem(
      name: 'Mobiles',
      icon: Icons.smartphone,
      iconColor: Color(0xFF546E7A),
      image: 'assets/categories/mobiles.png',
    ),
  ];

  static const List<Product> products = [
    Product(
      name: 'Multi Kit',
      price: 500,
      rating: 4.6,
      reviewCount: 86,
      icon: Icons.brush,
      iconColor: Color(0xFFE56BA0),
      image: 'assets/products/multi_kit.png',
      category: 'Beauty',
      description:
          'A complete makeup kit with brushes, a compact and everyday '
          'essentials, presented in a soft pink travel case.',
    ),
    Product(
      name: 'Lipstick',
      price: 400,
      rating: 4.6,
      reviewCount: 86,
      icon: Icons.colorize,
      iconColor: Color(0xFFD64545),
      image: 'assets/products/lipstick.png',
      category: 'Beauty',
      description:
          'Long-wear matte lipstick set with a rich colour payoff that '
          'stays comfortable all day.',
    ),
    Product(
      name: 'Perfume',
      price: 350,
      rating: 4.8,
      reviewCount: 52,
      icon: Icons.spa,
      iconColor: Color(0xFFB07A45),
      category: 'Beauty',
      description:
          'A warm floral fragrance with notes of amber and vanilla, ideal '
          'for day-to-night wear.',
    ),
    Product(
      name: 'Palette',
      price: 620,
      rating: 4.7,
      reviewCount: 120,
      icon: Icons.palette,
      iconColor: Color(0xFF8E5BD0),
      category: 'Beauty',
      description:
          'Highly pigmented eyeshadow palette with a blend of matte and '
          'shimmer shades.',
    ),
    Product(
      name: 'T-Shirt',
      price: 120,
      rating: 4.4,
      reviewCount: 64,
      icon: Icons.checkroom,
      iconColor: Color(0xFF4A90D9),
      category: 'Shirt',
      description: 'Soft cotton crew-neck tee with a relaxed everyday fit.',
    ),
    Product(
      name: 'Handbag',
      price: 890,
      rating: 4.9,
      reviewCount: 41,
      icon: Icons.shopping_bag,
      iconColor: Color(0xFFC9873F),
      category: 'Woman Bag',
      description:
          'Structured shoulder bag with a roomy interior and gold-tone '
          'hardware.',
    ),
    Product(
      name: 'Sofa',
      price: 12500,
      rating: 4.5,
      reviewCount: 18,
      icon: Icons.weekend,
      iconColor: Color(0xFFB07A45),
      category: 'Home',
      description:
          'Three-seater fabric sofa with deep cushioning and a durable '
          'hardwood frame.',
    ),
    Product(
      name: 'Smartphone',
      price: 32000,
      rating: 4.6,
      reviewCount: 210,
      icon: Icons.smartphone,
      iconColor: Color(0xFF546E7A),
      category: 'Mobiles',
      description:
          'A 5G phone with a vivid 6.5" display, all-day battery and a '
          'versatile triple camera.',
    ),
  ];

  static List<Product> get recommended => products.take(4).toList();

  static List<Product> byCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}
