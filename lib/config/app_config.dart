import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Punto único de acceso a la configuración leída desde el archivo `.env`.
///
/// Si el archivo no existe o una variable no está definida, la aplicación
/// continúa funcionando con valores por defecto seguros.
class AppConfig {
  AppConfig._();

  static const String defaultBaseUrl = 'https://api-colombia.com/api/v1';
  static const String defaultAppName = 'Colombia en Datos';
  static const int defaultTimeoutSeconds = 15;

  static bool _isLoaded = false;

  static String apiBaseUrl = defaultBaseUrl;
  static int timeoutSeconds = defaultTimeoutSeconds;
  static String appName = defaultAppName;

  /// Carga las variables de entorno. Debe llamarse antes de `runApp`.
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
      _isLoaded = true;
    } catch (_) {
      // El archivo .env es opcional: se usan los valores por defecto.
      _isLoaded = false;
    }

    if (!_isLoaded) return;

    apiBaseUrl = _normalizeUrl(
      dotenv.maybeGet('API_BASE_URL') ?? defaultBaseUrl,
    );
    appName = dotenv.maybeGet('APP_NAME') ?? defaultAppName;
    timeoutSeconds =
        int.tryParse(dotenv.maybeGet('API_TIMEOUT_SECONDS') ?? '') ??
        defaultTimeoutSeconds;
  }

  static String _normalizeUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return defaultBaseUrl;
    return trimmed.endsWith('/')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }

  static Duration get timeout => Duration(seconds: timeoutSeconds);
}
