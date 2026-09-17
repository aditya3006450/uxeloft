import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color _brand = Color(0xFF1A9EB7);
  static const Color _titleColor = Color(0xFFFFAF00);
  static const Color _bodyColor = Color(0xFF8B8B8B);

  static const List<Color> _gradientColors = [
    Color(0xFFFF7D00),
    Color(0xFFFFB400),
  ];

  static const String _lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
      'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '
      'ad minim veniam, quis nostrud exercitation.';

  static const List<String> _titles = [
    'Online Payments',
    'Online Shopping',
    'Home Delivery',
  ];

  static const List<String> _assets = [
    'assets/online payments landing.svg',
    'assets/online shopping.svg',
    'assets/Home Delivery Landing.svg',
  ];

  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _next() {
    if (_currentPage == _titles.length - 1) {
      _goToLogin();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.33;

    return Scaffold(
      backgroundColor: _brand,
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: _titles.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Center(
                child: SvgPicture.asset(_assets[index], fit: BoxFit.contain),
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
        height: sheetHeight,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    _titles[_currentPage],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _titleColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: const Text(
                      _lorem,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _bodyColor,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 56,
              child: Stack(
                alignment: .center,
                children: [
                  TextButton(
                    onPressed: _goToLogin,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: _gradientColors,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Skip >>',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: _gradientColors,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _next,
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
