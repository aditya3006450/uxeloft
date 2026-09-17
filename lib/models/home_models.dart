import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color iconColor;
  final String? image;

  const CategoryItem({
    required this.name,
    required this.icon,
    this.iconColor = const Color(0xFFFFA800),
    this.image,
  });
}

class Product {
  final String name;
  final double price;
  final double rating;
  final int reviewCount;
  final IconData icon;
  final Color iconColor;
  final String? image;

  const Product({
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.icon,
    this.iconColor = Colors.pinkAccent,
    this.image,
  });
}
