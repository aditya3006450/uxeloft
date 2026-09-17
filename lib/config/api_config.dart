class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'OTP_API_BASE',
    defaultValue: 'https://uxeloft.vercel.app',
  );
}