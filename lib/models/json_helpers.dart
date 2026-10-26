/// Lectores tolerantes de JSON.
///
/// La API puede devolver `null` o tipos inesperados en algunos campos. Estas
/// funciones evitan que un dato defectuoso rompa toda la pantalla.
library;

String? textOrNull(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

String textOrEmpty(dynamic value) => textOrNull(value) ?? '';

int? intOrNull(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

double? doubleOrNull(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

Map<String, dynamic>? mapOrNull(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

List<String> stringList(dynamic value) {
  if (value is! List) return const <String>[];
  return value
      .map(textOrNull)
      .whereType<String>()
      .toList(growable: false);
}
