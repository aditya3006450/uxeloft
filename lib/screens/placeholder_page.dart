import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.primaryText),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: Center(
        child: Text(
          '$title page',
          style: const TextStyle(color: AppColors.secondaryText),
        ),
      ),
    );
  }
}
