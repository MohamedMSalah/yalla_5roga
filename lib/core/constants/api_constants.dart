class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.yalla5roga.com',
  );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String login = '/auth/login';
  static const String register = '/auth/register';
}
