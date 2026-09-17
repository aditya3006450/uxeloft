import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    Get.snackbar('Uxeloft', message);
  }

  Future<void> _sendOtp() async {
    if (_emailController.text.trim().isEmpty) {
      _showMessage('Enter your email first');
      return;
    }
    final result = await AuthController.to.sendOtp(_emailController.text);
    if (result.success) {
      _showMessage('OTP sent to ${_emailController.text.trim()}');
    } else {
      _showMessage(result.message ?? 'Failed to send OTP');
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      _showMessage('Enter the 6-digit code');
      return;
    }
    final result = await AuthController.to.verifyOtp(
      _emailController.text,
      _otpController.text,
    );
    if (result.success) {
      Get.offAll(const MyHomePage(title: 'Uxeloft'));
    } else {
      _showMessage(result.message ?? 'Verification failed');
    }
  }

  Future<void> _signInWithGoogle() async {
    final result = await AuthController.to.signInWithGoogle();
    if (result.success) {
      Get.offAll(const MyHomePage(title: 'Uxeloft'));
    } else {
      _showMessage(result.message ?? 'Google sign in failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                height: 200 * 80 / 150,
                child: SvgPicture.asset('assets/Landing Logo.svg'),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: AuthController.to.isSendingOtp.value
                          ? null
                          : _sendOtp,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF1A9EB7),
                      ),
                      child: AuthController.to.isSendingOtp.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Send OTP'),
                    ),
                  )),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Verification code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pin_outlined),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: AuthController.to.isVerifyingOtp.value
                          ? null
                          : _verifyOtp,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8600),
                      ),
                      child: AuthController.to.isVerifyingOtp.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Verify OTP'),
                    ),
                  )),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: AuthController.to.isSigningInWithGoogle.value
                          ? null
                          : _signInWithGoogle,
                      icon: AuthController.to.isSigningInWithGoogle.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.g_mobiledata, size: 28),
                      label: const Text('Continue with Google'),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}