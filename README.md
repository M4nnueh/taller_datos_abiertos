# Colombia en Datos — Taller de Datos Abiertos (Flutter)

Aplicación Flutter que consume la **API pública de Colombia**
([api-colombia.com](https://api-colombia.com/)) y muestra un **Dashboard**,
**Listado** y **Detalle** para siete colecciones de datos abiertos. El proyecto
sigue una estructura por capas y utiliza `go_router` para la navegación entre
pantallas.

## 1. API utilizada y endpoints seleccionados

- **API base:** `https://api-colombia.com/api/v1`
- **Documentación:** [Swagger API Colombia](https://api-colombia.com/swagger/index.html)
- **Autenticación:** no requiere clave. Las URLs se configuran en `.env`.

| Endpoint | Ruta base | Descripción |
| --- | --- | --- |
| Departamentos | `/Department` | Capital, región, municipios, superficie, población. |
| Presidentes | `/President` | Periodo de gobierno, partido político e imagen. |
| Áreas naturales | `/NaturalArea` | Parques nacionales y reservas protegidas. |
| Atractivos turísticos | `/TouristicAttraction` | Lugares para visitar y sus coordenadas. |
| Platos típicos | `/TypicalDish` | Platos tradicionales e ingredientes. |
| Aeropuertos | `/Airport` | Terminales aéreas y códigos IATA / OACI. |
| Regiones | `/Region` | Las regiones naturales de Colombia. |

Se supera el mínimo de **4 endpoints** solicitado en el taller.

## 2. Paquetes implementados

| Paquete | Versión | Uso |
| --- | --- | --- |
| `http` | `^1.6.0` | Peticiones HTTP (`GET`) a la API. |
| `go_router` | `^18.1.1` | Navegación con rutas con nombre y parámetros. |
| `flutter_dotenv` | `^6.0.1` | Configuración por variables de entorno (`.env`). |
| `flutter_lints` | `^6.0.0` | Reglas de análisis estático. |

## 3. Estructura del proyecto

```text
lib/
  config/          // configuración general y variables de entorno
    app_config.dart
    api_endpoints.dart
  models/          // modelos con fromJson y toJson
    catalog_item.dart
    department.dart
    president.dart
    natural_area.dart
    touristic_attraction.dart
    typical_dish.dart
    airport.dart
    region.dart
    json_helpers.dart
  routes/          // configuración de go_router
    app_router.dart
  services/        // llamadas HTTP (http)
    colombia_api_service.dart
    api_exception.dart
  themes/          // estilos o temas globales
    app_theme.dart
  utils/           // formateo de números y fechas
    formatters.dart
  views/           // pantallas principales
    dashboard_view.dart
    endpoint_list_view.dart
    endpoint_detail_view.dart
    not_found_view.dart
  widgets/         // componentes reutilizables
    endpoint_card.dart
    async_state_view.dart
    app_network_image.dart
    detail_info_tile.dart
  main.dart
```

## 4. Arquitectura y buenas prácticas

- **Separación por capas:** las vistas no conocen `http` ni las URLs; delegan en
  `ColombiaApiService`, que devuelve modelos tipados (`CatalogItem`) o una
  `ApiException` con un mensaje amigable.
- **Modelos:** cada modelo implementa `CatalogItem` (`id`, `title`, `subtitle`,
  `description`, `imageUrl`, `detailFields`) y ofrece `fromJson` / `toJson`.
  Los lectores de JSON (`json_helpers.dart`) toleran campos `null` o con tipos
  inesperados.
- **Estados:** carga (`LoadingState`), error (`ErrorState` con botón
  **Reintentar**) y éxito (`ListView.builder`), además de estado vacío.
- **Navegación:** rutas con nombre y parámetros de ruta (`:endpoint`, `:id`) y
  paso del elemento seleccionado por `extra`.
- **Configuración:** la URL base y los tiempos de espera se leen de `.env`
  mediante `flutter_dotenv`, con valores por defecto seguros.
- **Pruebas:** `flutter test` incluye pruebas de modelos, del servicio HTTP
  (con `MockClient`) y del widget principal.

## 5. Rutas implementadas con `go_router`

| Nombre | Ruta | Parámetros |
| --- | --- | --- |
| `dashboard` | `/` | — |
| `list` | `/catalog/:endpoint` | `endpoint`: segmento de la colección. |
| `detail` | `/catalog/:endpoint/:id` | `endpoint`, `id` del registro, `extra` con el item. |

Ejemplo de navegación:

```dart
context.pushNamed(
  RouteNames.detail,
  pathParameters: <String, String>{
    'endpoint': endpoint.routeSegment,
    'id': '${item.id}',
  },
  extra: item,
);
```

## 6. Ejemplo de respuesta JSON

`GET https://api-colombia.com/api/v1/Department/3`

```json
{
  "id": 3,
  "name": "Arauca",
  "description": "Arauca es uno de los treinta y dos departamentos...",
  "cityCapitalId": 143,
  "municipalities": 7,
  "surface": 23818,
  "population": 304978,
  "phonePrefix": "7",
  "regionId": 3,
  "cityCapital": { "id": 143, "name": "Arauca" }
}
```

## 7. Manejo de estados

- **Cargando:** indicador circular con mensaje contextual.
- **Error:** icono, mensaje amigable (incluye códigos de estado HTTP) y botón
  **Reintentar**.
- **Éxito:** `ListView.builder` con tarjetas y búsqueda local.
- **Vacío:** mensaje cuando no hay registros o no hay coincidencias.

## 8. Ejecución del proyecto

```bash
flutter pub get
flutter run
```

Para Android Studio, abre la carpeta del proyecto y ejecuta `main.dart` en un
emulador o dispositivo.

Variables de entorno (`.env`):

```env
API_BASE_URL=https://api-colombia.com/api/v1
API_TIMEOUT_SECONDS=15
APP_NAME=Colombia en Datos
```

Comprobaciones:

```bash
flutter analyze
flutter test
```

## 9. Capturas

Incluye en `docs/screenshots/` (crear la carpeta) las capturas del Dashboard,
Listado, Detalle y manejo de estados, y referencia aquí:

- `docs/screenshots/dashboard.png`
- `docs/screenshots/listado.png`
- `docs/screenshots/detalle.png`
- `docs/screenshots/estados.png`

## 10. Flujo Git (GitFlow)

- `main`: rama estable.
- `dev`: rama de integración.
- `feature/taller_api_colombia`: desarrollo del taller.
- Flujo: `feature` → Pull Request → `dev` → merge a `main`.

## 11. Entregables

1. Repositorio público `taller_datos_abiertos` con ramas `main`, `dev` y
   `feature/taller_api_colombia`.
2. PDF con la descripción del trabajo (endpoints usados, estructura del proyecto
   y paquetes implementados).
3. Video mostrando el funcionamiento y el proceso de desarrollo.
