/// Contrato común de todos los recursos que se muestran en la aplicación.
///
/// Permite que una sola pantalla de listado y una sola pantalla de detalle
/// trabajen con departamentos, presidentes, platos típicos, etc., sin perder
/// el tipado propio de cada modelo.
abstract class CatalogItem {
  int get id;
  String get title;
  String get subtitle;
  String get description;
  String? get imageUrl;
  List<DetailField> get detailFields;
}

/// Fila de información que se muestra en la pantalla de detalle.
class DetailField {
  const DetailField({required this.label, required this.value});

  final String label;
  final String value;
}
