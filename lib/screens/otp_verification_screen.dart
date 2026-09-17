import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const _teal = Color(0xFF17A2B8);
  static const _lightCyanBg = Color(0xFFE8F4F8);
  static const _textDark = Color(0xFF1F2937);
  static const _textGray = Color(0xFF6B7280);
  static const _borderColor = Color(0xFFD1D5DB);

  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _otpCode =>
      _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otpCode.length == 4;

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _showMessage(String message) {
    Get.snackbar('Uxeloft', message);
  }

  Future<void> _verify() async {
    if (!_isOtpComplete) {
      _showMessage('Enter the 4-digit code');
      return;
    }
    final result = await AuthController.to.verifyOtp(
      widget.email,
      _otpCode,
    );
    if (result.success) {
      Get.offAllNamed('/home');
    } else {
      _showMessage(result.message ?? 'Verification failed');
    }
  }

  Future<void> _resend() async {
    final result = await AuthController.to.sendOtp(widget.email);
    _showMessage(
      result.success ? 'OTP resent to ${widget.email}' : 'Failed to resend OTP',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildBackButton(),
              const SizedBox(height: 40),
              _buildTitle(),
              const SizedBox(height: 12),
              _buildDescription(),
              const SizedBox(height: 40),
              _buildOtpFields(),
              const SizedBox(height: 40),
              _buildVerifyButton(),
              const SizedBox(height: 16),
              _buildResendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: _lightCyanBg,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: _teal,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'OTP Verification',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: _textDark,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Enter the verification code we just sent on your email address.',
      style: TextStyle(
        fontSize: 14,
        color: _textGray,
        height: 1.5,
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 60,
          height: 60,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                _controllers[index - 1].clear();
                _focusNodes[index - 1].requestFocus();
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: _borderColor,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: _borderColor,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: _teal,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (value) => _onDigitChanged(index, value),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVerifyButton() {
    return Obx(() {
      final isLoading = AuthController.to.isVerifyingOtp.value;
      final enabled = _isOtpComplete && !isLoading;

      return SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton(
          onPressed: enabled ? _verify : null,
          style: FilledButton.styleFrom(
            backgroundColor: _teal,
            disabledBackgroundColor: _teal.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'VERIFY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildResendButton() {
    return Center(
      child: TextButton(
        onPressed: _resend,
        child: const Text(
          'Resend code',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textGray,
          ),
        ),
      ),
    );
  }
}
