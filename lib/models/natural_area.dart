import '../utils/formatters.dart';
import 'catalog_item.dart';
import 'json_helpers.dart';

/// Área natural protegida de Colombia.
class NaturalArea implements CatalogItem {
  const NaturalArea({
    required this.id,
    required this.name,
    this.departmentName,
    this.categoryName,
    this.daneCode,
    this.landArea,
    this.maritimeArea,
  });

  factory NaturalArea.fromJson(Map<String, dynamic> json) {
    final department = mapOrNull(json['department']);
    final category = mapOrNull(json['categoryNaturalArea']);
    return NaturalArea(
      id: intOrNull(json['id']) ?? 0,
      name: textOrNull(json['name']) ?? 'Área natural sin nombre',
      departmentName: textOrNull(department?['name']),
      categoryName: textOrNull(category?['name']),
      daneCode: intOrNull(json['daneCode']),
      landArea: doubleOrNull(json['landArea']),
      maritimeArea: doubleOrNull(json['maritimeArea']),
    );
  }

  @override
  final int id;
  final String name;
  final String? departmentName;
  final String? categoryName;
  final int? daneCode;
  final double? landArea;
  final double? maritimeArea;

  @override
  String get description {
    final category = categoryName ?? 'Área natural protegida';
    final department = departmentName ?? 'Colombia';
    return '$category ubicada en el departamento de $department. '
        'Hace parte del Sistema Nacional de Áreas Protegidas de Colombia.';
  }

  @override
  String get title => name;

  @override
  String get subtitle {
    final category = categoryName ?? 'Área natural';
    final department = departmentName ?? 'Colombia';
    return '$category · $department';
  }

  @override
  String? get imageUrl => null;

  @override
  List<DetailField> get detailFields => <DetailField>[
    DetailField(label: 'Categoría', value: categoryName ?? 'No disponible'),
    DetailField(
      label: 'Departamento',
      value: departmentName ?? 'No disponible',
    ),
    DetailField(
      label: 'Área terrestre',
      value: landArea == null
          ? 'No disponible'
          : '${formatDecimal(landArea)} ha',
    ),
    DetailField(
      label: 'Área marítima',
      value: maritimeArea == null
          ? 'No disponible'
          : '${formatDecimal(maritimeArea)} ha',
    ),
    DetailField(label: 'Código DANE', value: formatInteger(daneCode)),
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'department': departmentName == null
        ? null
        : <String, dynamic>{'name': departmentName},
    'categoryNaturalArea': categoryName == null
        ? null
        : <String, dynamic>{'name': categoryName},
    'daneCode': daneCode,
    'landArea': landArea,
    'maritimeArea': maritimeArea,
  };
}
