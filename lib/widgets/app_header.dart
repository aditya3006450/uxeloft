import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../screens/placeholder_page.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(color: AppColors.background),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.menu,
                size: 22,
                color: AppColors.primaryText,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 65,
                height: 38,
                child: SvgPicture.asset(
                  'assets/Landing Logo.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.to(
                () => const PlaceholderPage(title: 'Search'),
              ),
              icon: const Icon(
                Icons.search,
                size: 22,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 34,
            height: 34,
            child: Center(
              child: InkWell(
                onTap: () => Get.to(
                  () => const PlaceholderPage(title: 'Barcode Scanner'),
                ),
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 22,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}