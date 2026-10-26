/// Utilidades de formato para presentar los datos de la API en español.
library;

const List<String> _months = <String>[
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

String _groupThousands(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Formatea un entero con separador de miles: `304978` -> `304.978`.
String formatInteger(num? value) {
  if (value == null) return 'No disponible';
  final number = value.round();
  final digits = _groupThousands(number.abs().toString());
  return number < 0 ? '-$digits' : digits;
}

/// Formatea un decimal con coma decimal y puntos de miles: `4873.06` ->
/// `4.873,06`.
String formatDecimal(num? value, {int decimals = 2}) {
  if (value == null) return 'No disponible';
  final fixed = value.abs().toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final integerPart = _groupThousands(parts.first);
  final sign = value < 0 ? '-' : '';
  if (decimals == 0) return '$sign$integerPart';
  return '$sign$integerPart,${parts.last}';
}

/// Devuelve una fecha larga en español: `1887-06-04` -> `4 de junio de 1887`.
String formatDate(DateTime? date) {
  if (date == null) return 'No disponible';
  return '${date.day} de ${_months[date.month - 1]} de ${date.year}';
}

/// Devuelve el periodo presidencial en formato corto.
String formatPeriod(DateTime? start, DateTime? end) {
  final startYear = start?.year.toString() ?? '?';
  final endYear = end?.year.toString() ?? 'Actualidad';
  return '$startYear - $endYear';
}
