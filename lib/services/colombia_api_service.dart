import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_endpoints.dart';
import '../config/app_config.dart';
import '../models/catalog_item.dart';
import '../models/json_helpers.dart';
import 'api_exception.dart';

/// Servicio que centraliza las peticiones HTTP a API Colombia.
///
/// Las vistas no conocen `http` ni las URLs: solo llaman a este servicio y
/// reciben modelos tipados o una [ApiException] con un mensaje amigable.
class ColombiaApiService {
  ColombiaApiService({http.Client? client, String? baseUrl, Duration? timeout})
    : _client = client ?? http.Client(),
      _ownsClient = client == null,
      _baseUrl = baseUrl ?? AppConfig.apiBaseUrl,
      _timeout = timeout ?? AppConfig.timeout;

  final http.Client _client;
  final bool _ownsClient;
  final String _baseUrl;
  final Duration _timeout;

  /// Obtiene todos los registros de un endpoint.
  Future<List<CatalogItem>> fetchList(ApiEndpoint endpoint) async {
    final decoded = await _get('/${endpoint.apiPath}');
    if (decoded is! List) {
      throw const ApiException(
        'La API devolvió un formato inesperado al consultar el listado.',
      );
    }

    final items = <CatalogItem>[];
    for (final rawItem in decoded) {
      final map = mapOrNull(rawItem);
      if (map == null) continue;
      try {
        items.add(endpoint.fromJson(map));
      } catch (_) {
        // Un registro defectuoso no debe impedir mostrar el resto.
        continue;
      }
    }
    return items;
  }

  /// Obtiene el detalle de un registro por su identificador.
  Future<CatalogItem> fetchDetail(ApiEndpoint endpoint, int id) async {
    final decoded = await _get('/${endpoint.apiPath}/$id');
    final map = mapOrNull(decoded);
    if (map == null) {
      throw const ApiException(
        'La API devolvió un formato inesperado al consultar el detalle.',
      );
    }
    try {
      return endpoint.fromJson(map);
    } catch (_) {
      throw const ApiException(
        'No fue posible interpretar la información del registro.',
      );
    }
  }

  Future<dynamic> _get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');

    try {
      final response = await _client
          .get(uri, headers: const <String, String>{'Accept': 'application/json'})
          .timeout(_timeout);

      if (response.statusCode == 404) {
        throw const ApiException(
          'No se encontró el recurso solicitado.',
          statusCode: 404,
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          'La API respondió con el código ${response.statusCode}. '
          'Intenta nuevamente en unos segundos.',
          statusCode: response.statusCode,
        );
      }

      final body = utf8.decode(response.bodyBytes);
      if (body.trim().isEmpty) {
        throw const ApiException('La API devolvió una respuesta vacía.');
      }

      return jsonDecode(body);
    } on TimeoutException {
      throw const ApiException(
        'La solicitud tardó demasiado. Verifica tu conexión e intenta de nuevo.',
      );
    } on http.ClientException {
      throw const ApiException(
        'No fue posible conectar con API Colombia. '
        'Revisa tu conexión a internet.',
      );
    } on FormatException {
      throw const ApiException(
        'La respuesta de la API no tiene un formato JSON válido.',
      );
    }
  }

  void dispose() {
    if (_ownsClient) _client.close();
  }
}
