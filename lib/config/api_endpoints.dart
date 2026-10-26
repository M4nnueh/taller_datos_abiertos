import 'package:flutter/material.dart';

import '../models/airport.dart';
import '../models/catalog_item.dart';
import '../models/department.dart';
import '../models/natural_area.dart';
import '../models/president.dart';
import '../models/region.dart';
import '../models/touristic_attraction.dart';
import '../models/typical_dish.dart';

/// Catálogo de recursos de API Colombia que consume la aplicación.
///
/// Cada valor reúne los datos necesarios para el Dashboard, el listado y el
/// detalle: ruta del endpoint, segmento de URL, textos, icono, color y la
/// función que convierte el JSON en un modelo tipado.
enum ApiEndpoint {
  departments(
    apiPath: 'Department',
    routeSegment: 'departamentos',
    title: 'Departamentos',
    menuDescription: 'Los 33 departamentos con su capital, población y superficie.',
    icon: Icons.map_outlined,
    color: Color(0xFF003893),
    fromJson: Department.fromJson,
  ),
  presidents(
    apiPath: 'President',
    routeSegment: 'presidentes',
    title: 'Presidentes',
    menuDescription: 'Gobernantes que han marcado la historia del país.',
    icon: Icons.account_balance_outlined,
    color: Color(0xFF6A4C93),
    fromJson: President.fromJson,
  ),
  naturalAreas(
    apiPath: 'NaturalArea',
    routeSegment: 'areas-naturales',
    title: 'Áreas naturales',
    menuDescription: 'Parques nacionales y reservas naturales protegidas.',
    icon: Icons.forest_outlined,
    color: Color(0xFF2E7D32),
    fromJson: NaturalArea.fromJson,
  ),
  attractions(
    apiPath: 'TouristicAttraction',
    routeSegment: 'atractivos',
    title: 'Atractivos turísticos',
    menuDescription: 'Lugares imperdibles para visitar en Colombia.',
    icon: Icons.landscape_outlined,
    color: Color(0xFFE65100),
    fromJson: TouristicAttraction.fromJson,
  ),
  dishes(
    apiPath: 'TypicalDish',
    routeSegment: 'platos-tipicos',
    title: 'Platos típicos',
    menuDescription: 'Sabores tradicionales de cada región del país.',
    icon: Icons.restaurant_outlined,
    color: Color(0xFFCE1126),
    fromJson: TypicalDish.fromJson,
  ),
  airports(
    apiPath: 'Airport',
    routeSegment: 'aeropuertos',
    title: 'Aeropuertos',
    menuDescription: 'Terminales aéreas y códigos IATA / OACI.',
    icon: Icons.flight_takeoff_outlined,
    color: Color(0xFF006D77),
    fromJson: Airport.fromJson,
  ),
  regions(
    apiPath: 'Region',
    routeSegment: 'regiones',
    title: 'Regiones',
    menuDescription: 'Las seis regiones naturales del territorio colombiano.',
    icon: Icons.public_outlined,
    color: Color(0xFF3F51B5),
    fromJson: Region.fromJson,
  );

  const ApiEndpoint({
    required this.apiPath,
    required this.routeSegment,
    required this.title,
    required this.menuDescription,
    required this.icon,
    required this.color,
    required this.fromJson,
  });

  final String apiPath;
  final String routeSegment;
  final String title;
  final String menuDescription;
  final IconData icon;
  final Color color;
  final CatalogItem Function(Map<String, dynamic> json) fromJson;

  String get listLocation => '/catalog/$routeSegment';

  String detailLocation(int id) => '$listLocation/$id';

  static ApiEndpoint? fromRoute(String routeSegment) {
    for (final endpoint in values) {
      if (endpoint.routeSegment == routeSegment) return endpoint;
    }
    return null;
  }
}
