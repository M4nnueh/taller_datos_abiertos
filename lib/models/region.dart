import 'catalog_item.dart';
import 'json_helpers.dart';

/// Región natural de Colombia.
class Region implements CatalogItem {
  const Region({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    id: intOrNull(json['id']) ?? 0,
    name: textOrNull(json['name']) ?? 'Región sin nombre',
    description: textOrEmpty(json['description']),
  );

  @override
  final int id;
  final String name;
  @override
  final String description;

  @override
  String get title => name;

  @override
  String get subtitle => 'Región natural de Colombia';

  @override
  String? get imageUrl => null;

  @override
  List<DetailField> get detailFields => const <DetailField>[
    DetailField(label: 'País', value: 'Colombia'),
    DetailField(label: 'Tipo', value: 'Región natural'),
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
  };
}
