import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uxeloft/screens/home_screen.dart';
import 'package:uxeloft/widgets/app_bottom_nav.dart';
import 'package:uxeloft/widgets/promotional_carousel.dart';

void main() {
  testWidgets('Home screen matches the reference layout anchors',
      (tester) async {
    tester.view.physicalSize = const Size(375, 1091);
    tester.view.devicePixelRatio = 1.0;
    tester.view.padding = const FakeViewPadding(top: 40);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(home: MyHomePage(title: 'Uxeloft')),
    );
    await tester.pump();

    expect(find.text('Hi, Andrea'), findsOneWidget);
    expect(find.text('What are you looking for\ntoday?'), findsOneWidget);
    expect(find.text('Recommend'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(tester.takeException(), isNull);

    final bannerTop = tester.getTopLeft(find.byType(PromoBanner).first).dy;
    final bannerSize = tester.getSize(find.byType(PromoBanner).first);
    expect(bannerTop, inInclusiveRange(190, 275));
    expect(bannerSize.height, closeTo(213, 1));
    expect(bannerSize.width, 375);

    expect(find.byType(AppBottomNav), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -620));
    await tester.pump();

    expect(find.text('Multi Kit'), findsOneWidget);
    expect(find.text('Lipstick'), findsOneWidget);
    expect(find.text('Add'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
