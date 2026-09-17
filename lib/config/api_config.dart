class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'OTP_API_BASE',
    defaultValue: 'http://10.0.2.2:3000',
  );
}