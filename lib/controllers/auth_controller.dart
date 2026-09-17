import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class AuthController extends GetxController {
  static const String boxName = 'auth';
  static const String keyIsLoggedIn = 'isLoggedIn';

  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleInitialized = false;

  late final Box _box;

  final RxBool isLoggedIn = false.obs;
  final Rxn<User> user = Rxn<User>();

  final RxBool isSendingOtp = false.obs;
  final RxBool isVerifyingOtp = false.obs;
  final RxBool isSigningInWithGoogle = false.obs;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box(boxName);
    isLoggedIn.value = _box.get(keyIsLoggedIn, defaultValue: false) as bool;

    _auth.authStateChanges().listen((firebaseUser) {
      user.value = firebaseUser;
      isLoggedIn.value = firebaseUser != null;
      _box.put(keyIsLoggedIn, firebaseUser != null);
    });
  }

  Map<String, String> _headers() => {'Content-Type': 'application/json'};

  Future<({bool success, String? message})> sendOtp(String email) async {
    isSendingOtp.value = true;
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/send-otp'),
        headers: _headers(),
        body: jsonEncode({'email': email.trim()}),
      );
      if (response.statusCode == 200) {
        return (success: true, message: null);
      }
      final data = _tryDecode(response.body);
      return (
        success: false,
        message: data?['error'] as String? ?? 'Failed to send OTP',
      );
    } catch (_) {
      return (success: false, message: 'Failed to send OTP');
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<({bool success, String? message})> verifyOtp(
    String email,
    String code,
  ) async {
    isVerifyingOtp.value = true;
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/verify-otp'),
        headers: _headers(),
        body: jsonEncode({'email': email.trim(), 'code': code.trim()}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String;
        await _auth.signInWithCustomToken(token);
        return (success: true, message: null);
      }
      final data = _tryDecode(response.body);
      return (
        success: false,
        message: data?['error'] as String? ?? 'Verification failed',
      );
    } catch (_) {
      return (success: false, message: 'Verification failed');
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  Map<String, dynamic>? _tryDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<({bool success, String? message})> signInWithGoogle() async {
    isSigningInWithGoogle.value = true;
    try {
      if (!_googleInitialized) {
        await _googleSignIn.initialize();
        _googleInitialized = true;
      }
      final googleUser = await _googleSignIn.authenticate();
      final auth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
      await _auth.signInWithCredential(credential);
      return (success: true, message: null);
    } on GoogleSignInException catch (e) {
      return (success: false, message: e.description ?? 'Google sign in failed');
    } on FirebaseAuthException catch (e) {
      return (success: false, message: e.message);
    } catch (_) {
      return (success: false, message: 'Something went wrong');
    } finally {
      isSigningInWithGoogle.value = false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}