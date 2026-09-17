import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('home assets are bundled and load', () async {
    const assets = [
      'assets/banners/banner_1.png',
      'assets/categories/beauty.png',
      'assets/categories/offers.png',
      'assets/categories/fashion.png',
      'assets/categories/home.png',
      'assets/categories/shirt.png',
      'assets/categories/woman_bag.png',
      'assets/categories/dress.png',
      'assets/categories/mobiles.png',
      'assets/products/multi_kit.png',
      'assets/products/lipstick.png',
    ];

    for (final path in assets) {
      final data = await rootBundle.load(path);
      expect(data.lengthInBytes, greaterThan(0), reason: path);
    }
  });
}
