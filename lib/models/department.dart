import '../utils/formatters.dart';
import 'catalog_item.dart';
import 'json_helpers.dart';

/// Departamento de Colombia.
class Department implements CatalogItem {
  const Department({
    required this.id,
    required this.name,
    required this.description,
    this.cityCapitalName,
    this.regionId,
    this.municipalities,
    this.surface,
    this.population,
    this.phonePrefix,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    final cityCapital = mapOrNull(json['cityCapital']);
    return Department(
      id: intOrNull(json['id']) ?? 0,
      name: textOrNull(json['name']) ?? 'Departamento sin nombre',
      description: textOrEmpty(json['description']),
      cityCapitalName: textOrNull(cityCapital?['name']),
      regionId: intOrNull(json['regionId']),
      municipalities: intOrNull(json['municipalities']),
      surface: doubleOrNull(json['surface']),
      population: intOrNull(json['population']),
      phonePrefix: textOrNull(json['phonePrefix']),
    );
  }

  @override
  final int id;
  final String name;
  @override
  final String description;
  final String? cityCapitalName;
  final int? regionId;
  final int? municipalities;
  final double? surface;
  final int? population;
  final String? phonePrefix;

  static const Map<int, String> _regions = <int, String>{
    1: 'Caribe',
    2: 'Pacífico',
    3: 'Orinoquía',
    4: 'Amazonía',
    5: 'Andina',
    6: 'Insular',
  };

  @override
  String get title => name;

  @override
  String get subtitle => 'Capital: ${cityCapitalName ?? 'No disponible'}';

  @override
  String? get imageUrl => null;

  @override
  List<DetailField> get detailFields => <DetailField>[
    DetailField(label: 'Capital', value: cityCapitalName ?? 'No disponible'),
    DetailField(
      label: 'Región',
      value: _regions[regionId] ?? 'No disponible',
    ),
    DetailField(label: 'Municipios', value: formatInteger(municipalities)),
    DetailField(
      label: 'Superficie',
      value: surface == null
          ? 'No disponible'
          : '${formatDecimal(surface, decimals: 0)} km²',
    ),
    DetailField(label: 'Población', value: formatInteger(population)),
    DetailField(
      label: 'Prefijo telefónico',
      value: phonePrefix == null ? 'No disponible' : '+57 $phonePrefix',
    ),
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
    'cityCapital': cityCapitalName == null
        ? null
        : <String, dynamic>{'name': cityCapitalName},
    'regionId': regionId,
    'municipalities': municipalities,
    'surface': surface,
    'population': population,
    'phonePrefix': phonePrefix,
  };
}
