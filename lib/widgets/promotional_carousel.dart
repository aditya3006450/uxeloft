import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class PromotionalCarousel extends StatefulWidget {
  const PromotionalCarousel({super.key});

  @override
  State<PromotionalCarousel> createState() => _PromotionalCarouselState();
}

class _PromotionalCarouselState extends State<PromotionalCarousel> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _currentPage = 0;
  static const int _bannerCount = 3;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      final next = (_currentPage + 1) % _bannerCount;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 213,
          child: PageView.builder(
            controller: _controller,
            itemCount: _bannerCount,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return PromoBanner(
                imagePath: index == 0 ? 'assets/banners/banner_1.png' : null,
                backgroundColor: index == 1
                    ? const Color(0xFFFF9D5C)
                    : const Color(0xFF7FD8C9),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        _Indicator(count: _bannerCount, activeIndex: _currentPage),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: active ? 7 : 6,
          height: active ? 7 : 6,
          decoration: BoxDecoration(
            color: active ? AppColors.accent : const Color(0xFFD9D9D9),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class PromoBanner extends StatelessWidget {
  const PromoBanner({
    super.key,
    required this.backgroundColor,
    this.imagePath,
  });

  final Color backgroundColor;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return SizedBox(
        width: double.infinity,
        child: Image.asset(
          imagePath!,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (_, _, _) => _buildComposed(),
        ),
      );
    }
    return _buildComposed();
  }

  Widget _buildComposed() {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 12,
            top: 14,
            child: Row(
              children: [
                _GeometricMark(),
                const SizedBox(width: 6),
                const Text(
                  'ebx.ao',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            top: 16,
            child: Row(
              children: List.generate(4, (i) {
                return Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(left: 5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryText,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            left: 96,
            bottom: 0,
            child: SizedBox(
              width: 120,
              height: 168,
              child: CustomPaint(painter: _ModelPainter()),
            ),
          ),
          Positioned(
            left: 14,
            top: 62,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'FOR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  'ONLINE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  'ORDER',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryText,
                    letterSpacing: 3,
                  ),
                ),
                SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '30%',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryText,
                          height: 1.05,
                        ),
                      ),
                      TextSpan(
                        text: '\nOFF',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryText,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'NEW ARRIVALS',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'JUST',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryText,
                    height: 1.05,
                  ),
                ),
                const Text(
                  'FOR',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryText,
                    height: 1.05,
                  ),
                ),
                Transform.rotate(
                  angle: -0.12,
                  child: const Text(
                    'you',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: AppColors.background,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 14,
            bottom: 10,
            child: Row(
              children: const [
                Icon(
                  Icons.location_on,
                  size: 12,
                  color: AppColors.primaryText,
                ),
                SizedBox(width: 4),
                Text(
                  'BUILDING NAME  MAIN ROAD, COUNTRY, 45612',
                  style: TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: AppColors.primaryText,
              child: const Text(
                'WWW.EBX.COM',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.background,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeometricMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.9,
      child: CustomPaint(
        size: const Size(12, 12),
        painter: _ZigZagPainter(),
      ),
    );
  }
}

class _ZigZagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primaryText;
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(0, h)
      ..lineTo(w * 0.4, h)
      ..lineTo(w * 0.4, h * 0.6)
      ..lineTo(w, h * 0.6)
      ..lineTo(w, h * 0.2)
      ..lineTo(w * 0.6, h * 0.2)
      ..lineTo(w * 0.6, 0)
      ..lineTo(w * 0.2, 0)
      ..lineTo(w * 0.2, h * 0.4)
      ..lineTo(0, h * 0.4)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModelPainter extends CustomPainter {
  static const Color _skin = Color(0xFFE8B98F);
  static const Color _hair = Color(0xFF2B2B2B);
  static const Color _dress = Color(0xFF4FC3D1);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.5;

    final shadow = Paint()..color = const Color(0x22000000);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, h - 4),
        width: w * 0.5,
        height: 8,
      ),
      shadow,
    );

    final legPaint = Paint()..color = _skin;
    final legTop = h * 0.70;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 14, legTop, 9, h - legTop - 2),
        const Radius.circular(4),
      ),
      legPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 5, legTop, 9, h - legTop - 2),
        const Radius.circular(4),
      ),
      legPaint,
    );

    final dressPaint = Paint()..color = _dress;
    final dress = Path()
      ..moveTo(cx - 18, h * 0.30)
      ..lineTo(cx + 18, h * 0.30)
      ..lineTo(cx + 34, h * 0.74)
      ..lineTo(cx - 34, h * 0.74)
      ..close();
    canvas.drawPath(dress, dressPaint);

    final armPaint = Paint()
      ..color = _skin
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - 18, h * 0.32),
      Offset(cx - 30, h * 0.55),
      armPaint,
    );
    canvas.drawLine(
      Offset(cx + 18, h * 0.32),
      Offset(cx + 30, h * 0.58),
      armPaint,
    );

    final neckPaint = Paint()..color = _skin;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, h * 0.27),
          width: 12,
          height: 14,
        ),
        const Radius.circular(4),
      ),
      neckPaint,
    );

    final headPaint = Paint()..color = _skin;
    final headCenter = Offset(cx, h * 0.16);
    final headR = w * 0.135;
    canvas.drawCircle(headCenter, headR, headPaint);

    final hairPaint = Paint()..color = _hair;
    final hairPath = Path()
      ..addArc(
        Rect.fromCircle(center: headCenter, radius: headR + 1),
        3.14159,
        3.14159,
      )
      ..close();
    canvas.drawPath(hairPath, hairPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(headCenter.dx - headR, headCenter.dy - 2, 4, headR + 8),
        const Radius.circular(2),
      ),
      hairPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          headCenter.dx + headR - 4,
          headCenter.dy - 2,
          4,
          headR + 8,
        ),
        const Radius.circular(2),
      ),
      hairPaint,
    );

    final bagPaint = Paint()..color = _hair;
    final bagRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx + 22, h * 0.62, 30, 34),
      const Radius.circular(3),
    );
    canvas.drawRRect(bagRect, bagPaint);
    canvas.drawArc(
      Rect.fromLTWH(cx + 30, h * 0.57, 14, 16),
      3.14159,
      3.14159,
      false,
      Paint()
        ..color = _hair
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}