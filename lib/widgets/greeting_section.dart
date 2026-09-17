import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key, required this.name});

  final String name;

  String get _greeting {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Hi there';
    final capitalized = trimmed[0].toUpperCase() + trimmed.substring(1);
    return 'Hi, $capitalized';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _greeting,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryText,
            ),
          ),
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
