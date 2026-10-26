import 'catalog_item.dart';
import 'json_helpers.dart';

/// Aeropuerto de Colombia.
class Airport implements CatalogItem {
  const Airport({
    required this.id,
    required this.name,
    this.iataCode,
    this.oaciCode,
    this.type,
    this.departmentName,
    this.cityName,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    final department = mapOrNull(json['department']);
    final city = mapOrNull(json['city']);
    return Airport(
      id: intOrNull(json['id']) ?? 0,
      name: textOrNull(json['name']) ?? 'Aeropuerto sin nombre',
      iataCode: textOrNull(json['iataCode']),
      oaciCode: textOrNull(json['oaciCode']),
      type: textOrNull(json['type']),
      departmentName: textOrNull(department?['name']),
      cityName: textOrNull(city?['name']),
    );
  }

  @override
  final int id;
  final String name;
  final String? iataCode;
  final String? oaciCode;
  final String? type;
  final String? departmentName;
  final String? cityName;

  @override
  String get title => name;

  @override
  String get subtitle {
    final code = iataCode == null || iataCode == 'N/A' ? null : iataCode;
    final city = cityName;
    if (code != null && city != null) return '$code · $city';
    if (city != null) return city;
    if (code != null) return code;
    return 'Aeropuerto de Colombia';
  }

  @override
  String get description =>
      'Aeropuerto ${type?.toLowerCase() ?? ''} ubicado en '
      '${cityName ?? 'Colombia'}'
      '${departmentName == null ? '' : ', departamento de $departmentName'}.'
          .replaceAll('  ', ' ');

  @override
  String? get imageUrl => null;

  @override
  List<DetailField> get detailFields => <DetailField>[
    DetailField(label: 'Código IATA', value: iataCode ?? 'No disponible'),
    DetailField(label: 'Código OACI', value: oaciCode ?? 'No disponible'),
    DetailField(label: 'Tipo', value: type ?? 'No disponible'),
    DetailField(
      label: 'Departamento',
      value: departmentName ?? 'No disponible',
    ),
    DetailField(label: 'Ciudad', value: cityName ?? 'No disponible'),
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'iataCode': iataCode,
    'oaciCode': oaciCode,
    'type': type,
    'department': departmentName == null
        ? null
        : <String, dynamic>{'name': departmentName},
    'city': cityName == null ? null : <String, dynamic>{'name': cityName},
  };
}
