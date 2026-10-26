import 'catalog_item.dart';
import 'json_helpers.dart';

/// Atractivo turístico de Colombia.
class TouristicAttraction implements CatalogItem {
  const TouristicAttraction({
    required this.id,
    required this.name,
    required this.description,
    this.images = const <String>[],
    this.latitude,
    this.longitude,
    this.cityName,
  });

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) {
    final city = mapOrNull(json['city']);
    return TouristicAttraction(
      id: intOrNull(json['id']) ?? 0,
      name: textOrNull(json['name']) ?? 'Atractivo sin nombre',
      description: textOrEmpty(json['description']),
      images: stringList(json['images']),
      latitude: textOrNull(json['latitude']),
      longitude: textOrNull(json['longitude']),
      cityName: textOrNull(city?['name']),
    );
  }

  @override
  final int id;
  final String name;
  @override
  final String description;
  final List<String> images;
  final String? latitude;
  final String? longitude;
  final String? cityName;

  @override
  String get title => name;

  @override
  String get subtitle =>
      cityName == null ? 'Atractivo turístico' : 'Ubicado en $cityName';

  @override
  String? get imageUrl => images.isEmpty ? null : images.first;

  @override
  List<DetailField> get detailFields => <DetailField>[
    DetailField(label: 'Ciudad', value: cityName ?? 'No disponible'),
    DetailField(label: 'Latitud', value: latitude ?? 'No disponible'),
    DetailField(label: 'Longitud', value: longitude ?? 'No disponible'),
    DetailField(label: 'Imágenes', value: '${images.length} disponible(s)'),
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
    'images': images,
    'latitude': latitude,
    'longitude': longitude,
    'city': cityName == null ? null : <String, dynamic>{'name': cityName},
  };
}
