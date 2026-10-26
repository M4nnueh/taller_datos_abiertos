import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:taller_datos_abiertos/config/api_endpoints.dart';
import 'package:taller_datos_abiertos/models/catalog_item.dart';
import 'package:taller_datos_abiertos/services/api_exception.dart';
import 'package:taller_datos_abiertos/services/colombia_api_service.dart';

http.Response jsonResponse(Object body, int statusCode) {
  return http.Response(
    jsonEncode(body),
    statusCode,
    headers: <String, String>{'content-type': 'application/json; charset=utf-8'},
  );
}

void main() {
  test('fetchList consulta la URL del endpoint y parsea los modelos', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'GET');
      expect(request.url.toString(), 'https://example.test/Department');
      return jsonResponse(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': 2,
          'name': 'Antioquia',
          'description': 'Departamento.',
          'municipalities': 125,
          'population': 6887306,
          'surface': 63612,
          'phonePrefix': '4',
          'regionId': 5,
        },
        <String, dynamic>{
          'id': 3,
          'name': 'Arauca',
          'description': 'Departamento.',
          'regionId': 3,
        },
      ], 200);
    });

    final ColombiaApiService service = ColombiaApiService(
      client: client,
      baseUrl: 'https://example.test',
    );

    final List<CatalogItem> items = await service.fetchList(
      ApiEndpoint.departments,
    );

    expect(items.length, 2);
    expect(items.first.title, 'Antioquia');
    expect(items.last.title, 'Arauca');
  });

  test('fetchDetail consulta el endpoint con el id', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(
        request.url.toString(),
        'https://example.test/President/3',
      );
      return jsonResponse(<String, dynamic>{
        'id': 3,
        'name': 'Rafael',
        'lastName': 'Nuñez',
        'description': 'Presidente.',
      }, 200);
    });

    final ColombiaApiService service = ColombiaApiService(
      client: client,
      baseUrl: 'https://example.test',
    );

    final CatalogItem president = await service.fetchDetail(
      ApiEndpoint.presidents,
      3,
    );

    expect(president.title, 'Rafael Nuñez');
  });

  test('un status 500 lanza ApiException con el código', () async {
    final MockClient client = MockClient(
      (_) async => http.Response('error', 500),
    );
    final ColombiaApiService service = ColombiaApiService(
      client: client,
      baseUrl: 'https://example.test',
    );

    expect(
      () => service.fetchList(ApiEndpoint.departments),
      throwsA(
        isA<ApiException>()
            .having((ApiException error) => error.statusCode, 'statusCode', 500)
            .having(
              (ApiException error) => error.message,
              'message',
              contains('500'),
            ),
      ),
    );
  });

  test('un status 404 informa que no se encontró el recurso', () async {
    final MockClient client = MockClient(
      (_) async => http.Response('not found', 404),
    );
    final ColombiaApiService service = ColombiaApiService(
      client: client,
      baseUrl: 'https://example.test',
    );

    expect(
      () => service.fetchDetail(ApiEndpoint.regions, 99),
      throwsA(
        isA<ApiException>().having(
          (ApiException error) => error.message,
          'message',
          contains('No se encontró'),
        ),
      ),
    );
  });

  test('un error de conexión produce un mensaje amigable', () async {
    final MockClient client = MockClient((_) async {
      throw http.ClientException('Sin red');
    });
    final ColombiaApiService service = ColombiaApiService(
      client: client,
      baseUrl: 'https://example.test',
    );

    expect(
      () => service.fetchList(ApiEndpoint.airports),
      throwsA(
        isA<ApiException>().having(
          (ApiException error) => error.message,
          'message',
          contains('conectar'),
        ),
      ),
    );
  });
}
