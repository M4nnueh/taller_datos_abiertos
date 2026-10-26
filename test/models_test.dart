import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/models/airport.dart';
import 'package:taller_datos_abiertos/models/department.dart';
import 'package:taller_datos_abiertos/models/natural_area.dart';
import 'package:taller_datos_abiertos/models/president.dart';
import 'package:taller_datos_abiertos/models/region.dart';
import 'package:taller_datos_abiertos/models/touristic_attraction.dart';
import 'package:taller_datos_abiertos/models/typical_dish.dart';

void main() {
  group('Department', () {
    test('parsea los campos anidados y serializa de nuevo', () {
      final Department department = Department.fromJson(<String, dynamic>{
        'id': 3,
        'name': 'Arauca',
        'description': 'Departamento de la Orinoquía.',
        'cityCapitalId': 143,
        'municipalities': 7,
        'surface': 23818,
        'population': 304978,
        'phonePrefix': '7',
        'regionId': 3,
        'cityCapital': <String, dynamic>{'id': 143, 'name': 'Arauca'},
      });

      expect(department.title, 'Arauca');
      expect(department.subtitle, 'Capital: Arauca');
      expect(department.detailFields.length, 6);
      expect(department.detailFields[1].value, 'Orinoquía');

      final Map<String, dynamic> json = department.toJson();
      expect(json['name'], 'Arauca');
      expect((json['cityCapital'] as Map<String, dynamic>)['name'], 'Arauca');
    });

    test('tolera campos nulos', () {
      final Department department = Department.fromJson(<String, dynamic>{
        'id': 1,
        'name': 'Desconocido',
      });

      expect(department.subtitle, 'Capital: No disponible');
      expect(department.detailFields.first.value, 'No disponible');
    });
  });

  test('President combina nombre, apellido y periodo', () {
    final President president = President.fromJson(<String, dynamic>{
      'id': 3,
      'name': 'Rafael',
      'lastName': 'Nuñez Moledo',
      'image': 'https://example.com/rafael.jpg',
      'startPeriodDate': '1887-06-04',
      'endPeriodDate': '1888-08-07',
      'politicalParty': 'Partido nacional',
      'description': 'Presidente de Colombia.',
      'city': <String, dynamic>{'id': 210, 'name': 'Cartagena'},
    });

    expect(president.title, 'Rafael Nuñez Moledo');
    expect(president.subtitle, contains('1887 - 1888'));
    expect(president.imageUrl, 'https://example.com/rafael.jpg');
    expect(president.detailFields[2].value, 'Cartagena');
  });

  test('NaturalArea construye su descripción con los datos anidados', () {
    final NaturalArea area = NaturalArea.fromJson(<String, dynamic>{
      'id': 1,
      'name': 'Cueva de los Guácharos',
      'departmentId': 18,
      'daneCode': 41,
      'landArea': 4873.0575,
      'maritimeArea': null,
      'department': <String, dynamic>{'id': 18, 'name': 'Huila'},
      'categoryNaturalArea': <String, dynamic>{
        'id': 7,
        'name': 'Parque Nacional Natural',
      },
    });

    expect(area.subtitle, 'Parque Nacional Natural · Huila');
    expect(area.description, contains('Huila'));
    expect(area.detailFields[2].value, '4.873,06 ha');
  });

  test('TouristicAttraction toma la primera imagen', () {
    final TouristicAttraction attraction = TouristicAttraction.fromJson(
      <String, dynamic>{
        'id': 36,
        'name': 'Hacienda Nápoles',
        'description': 'Parque temático.',
        'images': <String>['https://example.com/foto.jpg'],
        'latitude': '5.887894',
        'longitude': '-74.6418',
        'city': <String, dynamic>{'id': 88, 'name': 'Puerto Triunfo'},
      },
    );

    expect(attraction.title, 'Hacienda Nápoles');
    expect(attraction.subtitle, 'Ubicado en Puerto Triunfo');
    expect(attraction.imageUrl, 'https://example.com/foto.jpg');
    expect(attraction.detailFields.first.value, 'Puerto Triunfo');
  });

  test('TypicalDish conserva la URL original con espacios', () {
    final TypicalDish dish = TypicalDish.fromJson(<String, dynamic>{
      'id': 1,
      'name': 'Bandeja Paisa',
      'description': 'Plato tradicional.',
      'ingredients': 'Frijoles, arroz, chicharrón.',
      'imageUrl': 'https://example.com/1. Bandeja Paisa.jpg',
      'department': <String, dynamic>{'id': 2, 'name': 'Antioquia'},
    });

    expect(dish.subtitle, 'Antioquia · Plato típico');
    expect(dish.imageUrl, contains('Bandeja Paisa.jpg'));
    expect(dish.detailFields.first.value, 'Antioquia');
  });

  test('Airport arma un subtítulo útil', () {
    final Airport airport = Airport.fromJson(<String, dynamic>{
      'id': 45,
      'name': 'Base Aérea',
      'iataCode': 'N/A',
      'oaciCode': 'N/A',
      'type': 'Militar',
      'department': <String, dynamic>{'id': 2, 'name': 'Antioquia'},
      'city': <String, dynamic>{'id': 91, 'name': 'Rionegro'},
    });

    expect(airport.subtitle, 'Rionegro');
    expect(airport.description, contains('Rionegro'));
  });

  test('Region expone sus campos básicos', () {
    final Region region = Region.fromJson(<String, dynamic>{
      'id': 1,
      'name': 'Caribe',
      'description': 'Región del norte de Colombia.',
    });

    expect(region.title, 'Caribe');
    expect(region.subtitle, 'Región natural de Colombia');
    expect(region.toJson()['id'], 1);
  });
}
