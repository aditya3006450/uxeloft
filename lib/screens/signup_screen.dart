import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uxeloft/data/countries.dart';

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
  Country _selectedCountry = countries.firstWhere((c) => c.code == 'US');

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

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return _CountryPickerSheet(
              scrollController: scrollController,
              selectedCountry: _selectedCountry,
              onSelected: (country) {
                setState(() => _selectedCountry = country);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
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
                  GestureDetector(
                    onTap: _showCountryPicker,
                    child: Container(
                      width: 100,
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedCountry.flag, style: const TextStyle(fontSize: 18)),
                          Expanded(
                            child: Text(
                              _selectedCountry.dialCode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ],
                      ),
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
                    icon: SvgPicture.asset('assets/signup options/apple.svg', width: 32, height: 32),
                    onTap: () => Get.snackbar('Uxeloft', 'Apple sign in coming soon'),
                  ),
                  _socialButton(
                    label: 'Google',
                    icon: SvgPicture.asset('assets/signup options/google.svg', width: 32, height: 32),
                    onTap: () => Get.snackbar('Uxeloft', 'Google sign in coming soon'),
                  ),
                  _socialButton(
                    label: 'Facebook',
                    icon: SvgPicture.asset('assets/signup options/facebook.svg', width: 32, height: 32),
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

class _CountryPickerSheet extends StatefulWidget {
  final ScrollController scrollController;
  final Country selectedCountry;
  final ValueChanged<Country> onSelected;

  const _CountryPickerSheet({
    required this.scrollController,
    required this.selectedCountry,
    required this.onSelected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchController = TextEditingController();
  List<Country> _filtered = countries;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      _filtered = countries
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()) ||
              c.dialCode.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Select Country',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            onChanged: _filter,
            cursorColor: const Color(0xFF17A2B8),
            decoration: InputDecoration(
              hintText: 'Search country or code',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF9E9E9E)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _filter('');
                      },
                      icon: const Icon(Icons.clear, color: Color(0xFF9E9E9E)),
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final country = _filtered[index];
              final isSelected = country.code == widget.selectedCountry.code;
              return ListTile(
                leading: Text(country.flag, style: const TextStyle(fontSize: 28)),
                title: Text(
                  country.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: Text(
                  country.dialCode,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                selectedTileColor: const Color(0xFF17A2B8).withValues(alpha: 0.1),
                onTap: () => widget.onSelected(country),
              );
            },
          ),
        ),
      ],
    );
  }
}