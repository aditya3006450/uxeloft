import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const _teal = Color(0xFF17A2B8);
  static const _red = Color(0xFFE74C3C);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureRepeat = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _next() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final repeat = _repeatPasswordController.text;
    final phone = _phoneController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        repeat.isEmpty ||
        phone.isEmpty) {
      Get.snackbar('Uxeloft', 'Please fill in all fields');
      return;
    }
    if (password != repeat) {
      Get.snackbar('Uxeloft', 'Passwords do not match');
      return;
    }
    Get.snackbar('Uxeloft', 'Sign up coming soon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF1A1A1A)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 48),
              _field(
                controller: _emailController,
                hint: 'Email',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              _field(
                controller: _passwordController,
                hint: 'Special Characters',
                icon: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                obscure: _obscurePassword,
                showToggle: true,
                toggleValue: _obscurePassword,
                onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: 24),
              _field(
                controller: _repeatPasswordController,
                hint: 'Repeat Password',
                icon: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                obscure: _obscureRepeat,
                showToggle: true,
                toggleValue: _obscureRepeat,
                onToggle: () => setState(() => _obscureRepeat = !_obscureRepeat),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('🇮🇳', style: TextStyle(fontSize: 18)),
                        Text(
                          '+244',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _field(
                      controller: _phoneController,
                      hint: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              SizedBox(
                height: 54,
                child: FilledButton(
                  onPressed: _next,
                  style: FilledButton.styleFrom(
                    backgroundColor: _teal,
                    disabledBackgroundColor: _teal.withValues(alpha: 0.6),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'Or Continue With',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
_socialButton(
                    label: 'Apple',
                    icon: const _AppleLogo(size: 36),
                    onTap: () => Get.snackbar('Uxeloft', 'Apple sign in coming soon'),
                  ),
                  _socialButton(
                    label: 'Google',
                    icon: const _GoogleG(size: 34),
                    onTap: () => Get.snackbar('Uxeloft', 'Google sign in coming soon'),
                  ),
                  _socialButton(
                    label: 'Facebook',
                    icon: const Icon(Icons.facebook, size: 32),
                    onTap: () => Get.snackbar('Uxeloft', 'Facebook sign in coming soon'),
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    bool obscure = false,
    bool showToggle = false,
    bool toggleValue = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      cursorColor: _teal,
      style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade400),
        prefixIcon: icon == null ? null : Icon(icon, color: const Color(0xFF9E9E9E)),
        suffixIcon: showToggle
            ? IconButton(
                onPressed: onToggle,
                icon: Icon(
                  toggleValue
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF9E9E9E),
                ),
              )
            : null,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _teal, width: 1.8),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _GoogleG extends StatelessWidget {
  const _GoogleG({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF4285F4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: const Color(0xFF34A853),
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(width: 6, child: ColoredBox(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFFFBBC05),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(width: 6, child: ColoredBox(color: Colors.white)),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFEA4335),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppleLogo extends StatelessWidget {
  const _AppleLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: const _AppleLogoPainter(),
    );
  }
}

class _AppleLogoPainter extends CustomPainter {
  const _AppleLogoPainter();

  static final Path _path = _parseApplePath();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    canvas.drawPath(
      _path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = const Color(0xFF000000),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AppleLogoPainter oldDelegate) => false;

  static Path _parseApplePath() {
    const data =
        'M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.03 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.637-3.325 1.663-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09z'
        'M15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.56-1.702z';
    final tokens = data
        .replaceAllMapped(RegExp('[mMzc]'), (m) => ' ${m[0]} ')
        .split(RegExp('\\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    final path = Path();
    double currentX = 0, currentY = 0;
    double startX = 0, startY = 0;
    var index = 0;
    while (index < tokens.length) {
      final command = tokens[index++];
      switch (command) {
        case 'M':
          currentX = double.parse(tokens[index++]);
          currentY = double.parse(tokens[index++]);
          startX = currentX;
          startY = currentY;
          path.moveTo(currentX, currentY);
        case 'c':
          final dx1 = double.parse(tokens[index++]);
          final dy1 = double.parse(tokens[index++]);
          final dx2 = double.parse(tokens[index++]);
          final dy2 = double.parse(tokens[index++]);
          final dx = double.parse(tokens[index++]);
          final dy = double.parse(tokens[index++]);
          path.cubicTo(
            currentX + dx1,
            currentY + dy1,
            currentX + dx2,
            currentY + dy2,
            currentX + dx,
            currentY + dy,
          );
          currentX += dx;
          currentY += dy;
        case 'z':
          path.close();
          currentX = startX;
          currentY = startY;
      }
    }
    return path;
  }
}