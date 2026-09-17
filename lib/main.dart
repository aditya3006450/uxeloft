import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox(AuthController.boxName);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Uxeloft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A9EB7)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      getPages: [
        GetPage(name: '/home', page: () => const MyHomePage(title: 'Uxeloft')),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
      ],
      home: SplashScreen(
        onFinished: () {
          if (AuthController.to.isLoggedIn.value) {
            Get.offAllNamed('/home');
          } else {
            Get.offAllNamed('/onboarding');
          }
        },
      ),
    );
  }
}