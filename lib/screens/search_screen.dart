import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../data/shop_data.dart';
import '../models/home_models.dart';
import '../widgets/product_tile.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    if (_query.trim().isEmpty) {
      return ShopData.products;
    }
    final q = _query.toLowerCase();
    return ShopData.products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.category.toString().toLowerCase().contains(q) ||
          p.description.toString().toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredProducts;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (val) => setState(() => _query = val),
            style: const TextStyle(fontSize: 14, color: AppColors.primaryText),
            decoration: InputDecoration(
              hintText: 'Search products, categories...',
              hintStyle: const TextStyle(
                fontSize: 13.5,
                color: AppColors.secondaryText,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: AppColors.secondaryText,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 56,
                    color: AppColors.inactiveIcon,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No results for "$_query"',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Try searching for beauty, shirt, bag, or sofa.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: results.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
                color: AppColors.divider,
              ),
              itemBuilder: (context, index) {
                final product = results[index];
                return ProductTile(
                  product: product,
                  onTap: () =>
                      Get.to(() => ProductDetailScreen(product: product)),
                );
              },
            ),
    );
  }
}
