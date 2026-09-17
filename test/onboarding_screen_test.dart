import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:uxeloft/screens/onboarding_screen.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Widget app({int step = 0}) {
    return GetMaterialApp(
      initialRoute: '/onboarding',
      getPages: [
        GetPage(
          name: '/onboarding',
          page: () => OnboardingScreen(step: step),
        ),
        GetPage(
          name: '/login',
          page: () => const Scaffold(body: Text('Login page')),
        ),
      ],
    );
  }

  void usePhoneSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('Next navigates to the next onboarding step as a new page',
      (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Online Payments'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    expect(find.text('Online Shopping'), findsOneWidget);
    expect(find.text('Online Payments'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Final step Next goes to login', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(app(step: 2));
    await tester.pumpAndSettle();

    expect(find.text('Home Delivery'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    expect(find.text('Login page'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Skip goes to login', (tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip >>'));
    await tester.pumpAndSettle();

    expect(find.text('Login page'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
