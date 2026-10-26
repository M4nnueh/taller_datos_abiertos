import '../utils/formatters.dart';
import 'catalog_item.dart';
import 'json_helpers.dart';

/// Expresidente o presidente de Colombia.
class President implements CatalogItem {
  const President({
    required this.id,
    required this.name,
    required this.lastName,
    required this.description,
    this.image,
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty,
    this.cityName,
  });

  factory President.fromJson(Map<String, dynamic> json) {
    final city = mapOrNull(json['city']);
    return President(
      id: intOrNull(json['id']) ?? 0,
      name: textOrNull(json['name']) ?? '',
      lastName: textOrNull(json['lastName']) ?? '',
      description: textOrEmpty(json['description']),
      image: textOrNull(json['image']),
      startPeriodDate: DateTime.tryParse(textOrEmpty(json['startPeriodDate'])),
      endPeriodDate: DateTime.tryParse(textOrEmpty(json['endPeriodDate'])),
      politicalParty: textOrNull(json['politicalParty']),
      cityName: textOrNull(city?['name']),
    );
  }

  @override
  final int id;
  final String name;
  final String lastName;
  @override
  final String description;
  final String? image;
  final DateTime? startPeriodDate;
  final DateTime? endPeriodDate;
  final String? politicalParty;
  final String? cityName;

  @override
  String get title => '$name $lastName'.trim();

  @override
  String get subtitle {
    final party = politicalParty ?? 'Sin partido registrado';
    return '$party · ${formatPeriod(startPeriodDate, endPeriodDate)}';
  }

  @override
  String? get imageUrl => image;

  @override
  List<DetailField> get detailFields => <DetailField>[
    DetailField(
      label: 'Periodo',
      value:
          '${formatDate(startPeriodDate)} - ${formatDate(endPeriodDate)}',
    ),
    DetailField(
      label: 'Partido político',
      value: politicalParty ?? 'No disponible',
    ),
    DetailField(label: 'Ciudad', value: cityName ?? 'No disponible'),
  ];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'lastName': lastName,
    'description': description,
    'image': image,
    'startPeriodDate': startPeriodDate?.toIso8601String().split('T').first,
    'endPeriodDate': endPeriodDate?.toIso8601String().split('T').first,
    'politicalParty': politicalParty,
    'city': cityName == null ? null : <String, dynamic>{'name': cityName},
  };
}
