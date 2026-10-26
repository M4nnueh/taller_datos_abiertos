import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/api_endpoints.dart';
import '../models/catalog_item.dart';
import '../routes/app_router.dart';
import '../services/colombia_api_service.dart';
import '../themes/app_theme.dart';
import '../widgets/app_network_image.dart';
import '../widgets/async_state_view.dart';
import 'not_found_view.dart';

/// Listado de registros de un endpoint.
///
/// Muestra los estados de carga, error y éxito, permite buscar por título o
/// subtítulo y navega al detalle usando rutas con nombre de `go_router`.
class EndpointListView extends StatefulWidget {
  const EndpointListView({
    super.key,
    required this.endpointRoute,
    this.service,
  });

  final String endpointRoute;
  final ColombiaApiService? service;

  @override
  State<EndpointListView> createState() => _EndpointListViewState();
}

class _EndpointListViewState extends State<EndpointListView> {
  final TextEditingController _searchController = TextEditingController();

  ApiEndpoint? _endpoint;
  ColombiaApiService? _service;
  Future<List<CatalogItem>>? _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _endpoint = ApiEndpoint.fromRoute(widget.endpointRoute);
    final ApiEndpoint? endpoint = _endpoint;
    if (endpoint == null) return;

    _service = widget.service ?? ColombiaApiService();
    _future = _service!.fetchList(endpoint);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _service?.dispose();
    super.dispose();
  }

  void _reload() {
    final ApiEndpoint? endpoint = _endpoint;
    if (endpoint == null) return;
    setState(() {
      _future = _service!.fetchList(endpoint);
    });
  }

  Future<void> _refresh() async {
    final ApiEndpoint? endpoint = _endpoint;
    if (endpoint == null) return;
    final Future<List<CatalogItem>> request = _service!.fetchList(endpoint);
    setState(() {
      _future = request;
    });
    try {
      await request;
    } catch (_) {
      // El FutureBuilder muestra el error y ofrece reintentar.
    }
  }

  @override
  Widget build(BuildContext context) {
    final ApiEndpoint? endpoint = _endpoint;
    if (endpoint == null) {
      return NotFoundView(
        message: 'El endpoint "${widget.endpointRoute}" no está disponible.',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(endpoint.title),
        actions: <Widget>[
          IconButton(
            tooltip: 'Recargar',
            onPressed: _reload,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Icon(endpoint.icon, size: 17, color: endpoint.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    endpoint.menuDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (String value) {
                setState(() {
                  _query = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar en ${endpoint.title.toLowerCase()}',
                prefixIcon: const Icon(Icons.search_rounded, size: 21),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar búsqueda',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded, size: 19),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: AsyncStateView<List<CatalogItem>>(
              future: _future!,
              onRetry: _reload,
              loadingMessage:
                  'Cargando ${endpoint.title.toLowerCase()} desde API Colombia...',
              builder: (BuildContext context, List<CatalogItem> items) =>
                  _buildList(context, endpoint, items),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ApiEndpoint endpoint,
    List<CatalogItem> items,
  ) {
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        title: 'Sin registros',
        message: 'La API no devolvió información para esta colección.',
      );
    }

    final List<CatalogItem> filtered = _query.isEmpty
        ? items
        : items
              .where(
                (CatalogItem item) =>
                    item.title.toLowerCase().contains(_query) ||
                    item.subtitle.toLowerCase().contains(_query),
              )
              .toList(growable: false);

    if (filtered.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: 'Sin resultados',
        message: 'No encontramos coincidencias para "${_searchController.text}".',
      );
    }

    return RefreshIndicator(
      color: endpoint.color,
      onRefresh: _refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
        itemCount: filtered.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _ListHeader(
              endpoint: endpoint,
              total: items.length,
              showing: filtered.length,
            );
          }
          final CatalogItem item = filtered[index - 1];
          return _CatalogTile(
            endpoint: endpoint,
            item: item,
            onTap: () => context.pushNamed(
              RouteNames.detail,
              pathParameters: <String, String>{
                'endpoint': endpoint.routeSegment,
                'id': '${item.id}',
              },
              extra: item,
            ),
          );
        },
      ),
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader({
    required this.endpoint,
    required this.total,
    required this.showing,
  });

  final ApiEndpoint endpoint;
  final int total;
  final int showing;

  @override
  Widget build(BuildContext context) {
    final String label = showing == total
        ? '$total registro${total == 1 ? '' : 's'}'
        : '$showing de $total registros';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: endpoint.color.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: endpoint.color,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Desliza para actualizar',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({
    required this.endpoint,
    required this.item,
    required this.onTap,
  });

  final ApiEndpoint endpoint;
  final CatalogItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: item.imageUrl == null
                        ? Container(
                            color: endpoint.color.withValues(alpha: 0.10),
                            alignment: Alignment.center,
                            child: Icon(
                              endpoint.icon,
                              color: endpoint.color,
                              size: 25,
                            ),
                          )
                        : AppNetworkImage(
                            url: item.imageUrl,
                            fallbackIcon: endpoint.icon,
                            fallbackColor: endpoint.color,
                          ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.muted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
