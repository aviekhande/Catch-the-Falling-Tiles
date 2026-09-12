enum Environment {
  dev,
  prod,
}

class EnvConfig {
  EnvConfig._();

  static late Environment _environment;
  static late String _baseUrl;
  static late bool _enableLogging;
  static late Duration _connectTimeout;

  static Environment get environment => _environment;
  static String get baseUrl => _baseUrl;
  static bool get enableLogging => _enableLogging;
  static Duration get connectTimeout => _connectTimeout;

  static bool get isDev => _environment == Environment.dev;
  static bool get isProd => _environment == Environment.prod;

  static void init({
    Environment environment = Environment.dev,
    String? baseUrl,
    bool? enableLogging,
    Duration? connectTimeout,
  }) {
    _environment = environment;
    _connectTimeout = connectTimeout ?? const Duration(seconds: 10);

    switch (environment) {
      case Environment.dev:
        _baseUrl = baseUrl ?? 'https://api-dev.falling-tiles.local/v1';
        _enableLogging = enableLogging ?? true;
        break;
      case Environment.prod:
        _baseUrl = baseUrl ?? 'https://api.falling-tiles.com/v1';
        _enableLogging = enableLogging ?? false;
        break;
    }
  }
}
