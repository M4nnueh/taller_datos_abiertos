import 'catalog_item.dart';
import 'json_helpers.dart';

/// Plato típico de Colombia.
class TypicalDish implements CatalogItem {
  const TypicalDish({
    required this.id,
    required this.name,
    required this.description,
    this.ingredients,
    this.image,
    this.departmentName,
  });

  factory TypicalDish.fromJson(Map<String, dynamic> json) {
    final department = mapOrNull(json['department']);
    return TypicalDish(
      id: intOrNull(json['id']) ?? 0,
      name: textOrNull(json['name']) ?? 'Plato sin nombre',
      description: textOrEmpty(json['description']),
      ingredients: textOrNull(json['ingredients']),
      image: textOrNull(json['imageUrl']),
      departmentName: textOrNull(department?['name']),
    );
  }

  @override
  final int id;
  final String name;
  @override
  final String description;
  final String? ingredients;
  final String? image;
  final String? departmentName;

  @override
  String get title => name;

  @override
  String get subtitle =>
      '${departmentName ?? 'Colombia'} · Plato típico';

  @override
  String? get imageUrl => image;

  @override
  List<DetailField> get detailFields => <DetailField>[
    DetailField(label: 'Departamento', value: departmentName ?? 'No disponible'),
    DetailField(
      label: 'Ingredientes',
      value: ingredients ?? 'No disponible',
    ),
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
    'ingredients': ingredients,
    'imageUrl': image,
    'department': departmentName == null
        ? null
        : <String, dynamic>{'name': departmentName},
  };
}
