import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../models/home_models.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_header.dart';
import '../widgets/category_grid.dart';
import '../widgets/category_tabs.dart';
import '../widgets/product_card.dart';
import '../widgets/promotional_carousel.dart';
import 'placeholder_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title = 'Uxeloft'});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navIndex = 0;

  static const List<CategoryItem> _categories = [
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
      name: 'Woman\nBag',
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

  static const List<Product> _products = [
    Product(
      name: 'Multi Kit',
      price: 500,
      rating: 4.6,
      reviewCount: 86,
      icon: Icons.brush,
      iconColor: Color(0xFFE56BA0),
      image: 'assets/products/multi_kit.png',
    ),
    Product(
      name: 'Lipstick',
      price: 400,
      rating: 4.6,
      reviewCount: 86,
      icon: Icons.colorize,
      iconColor: Color(0xFFD64545),
      image: 'assets/products/lipstick.png',
    ),
    Product(
      name: 'Perfume',
      price: 350,
      rating: 4.8,
      reviewCount: 52,
      icon: Icons.spa,
      iconColor: Color(0xFFB07A45),
    ),
    Product(
      name: 'Palette',
      price: 620,
      rating: 4.7,
      reviewCount: 120,
      icon: Icons.palette,
      iconColor: Color(0xFF8E5BD0),
    ),
  ];

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    switch (index) {
      case 0:
        setState(() => _navIndex = index);
        break;
      case 1:
        setState(() => _navIndex = index);
        break;
      case 2:
        Get.snackbar(
          'Messages',
          'You have no new messages',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 3:
        Get.to(() => const PlaceholderPage(title: 'Cart'));
        break;
      case 4:
        Get.to(() => const PlaceholderPage(title: 'Private'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _AppDrawer(),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar(
              pinned: true,
              toolbarHeight: 70,
              title: AppHeader(),
              titleSpacing: 0,
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
            ),
            SliverToBoxAdapter(child: _GreetingSection()),
            SliverToBoxAdapter(child: PromotionalCarousel()),
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            const SliverToBoxAdapter(child: CategoryTabs()),
            const SliverToBoxAdapter(child: SizedBox(height: 6)),
            SliverToBoxAdapter(
              child: CategoryGrid(
                categories: _categories,
                onItemTap: (item) => Get.to(
                  () => PlaceholderPage(title: item.name.replaceAll('\n', ' ')),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProductCard(product: _products[index]),
                  childCount: _products.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final name = AuthController.to.username.value;
            return Text(
              name.isNotEmpty ? 'Hi, $name' : 'Hi there',
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryText,
              ),
            );
          }),
          const SizedBox(height: 9),
          const Text(
            'What are you looking for\ntoday?',
            style: TextStyle(
              fontSize: 25,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const ListTile(
              leading: Icon(Icons.home_outlined, color: AppColors.accent),
              title: Text('Home'),
            ),
            const ListTile(
              leading: Icon(Icons.grid_view_outlined),
              title: Text('Category'),
            ),
            const ListTile(
              leading: Icon(Icons.shopping_bag_outlined),
              title: Text('My Orders'),
            ),
            const ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Sign Out'),
              onTap: () async {
                await AuthController.to.signOut();
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
