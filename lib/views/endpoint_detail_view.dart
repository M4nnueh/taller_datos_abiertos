import 'package:flutter/material.dart';

import '../config/api_endpoints.dart';
import '../models/catalog_item.dart';
import '../services/colombia_api_service.dart';
import '../widgets/app_network_image.dart';
import '../widgets/async_state_view.dart';
import '../widgets/detail_info_tile.dart';
import 'not_found_view.dart';

/// Pantalla de detalle de un registro (maestro - detalle con go_router).
///
/// El elemento llega por `extra` desde el listado. Si se entra por enlace
/// directo (sin `extra`), se consulta el detalle del registro por su id.
class EndpointDetailView extends StatefulWidget {
  const EndpointDetailView({
    super.key,
    required this.endpointRoute,
    required this.id,
    this.extra,
    this.service,
  });

  final String endpointRoute;
  final int? id;
  final Object? extra;
  final ColombiaApiService? service;

  @override
  State<EndpointDetailView> createState() => _EndpointDetailViewState();
}

class _EndpointDetailViewState extends State<EndpointDetailView> {
  ApiEndpoint? _endpoint;
  ColombiaApiService? _service;
  CatalogItem? _item;
  Future<CatalogItem>? _future;

  @override
  void initState() {
    super.initState();
    _endpoint = ApiEndpoint.fromRoute(widget.endpointRoute);
    final ApiEndpoint? endpoint = _endpoint;
    final int? id = widget.id;
    if (endpoint == null || id == null) return;

    _service = widget.service ?? ColombiaApiService();

    final Object? extra = widget.extra;
    if (extra is CatalogItem && extra.id == id) {
      _item = extra;
    } else {
      _future = _service!.fetchDetail(endpoint, id);
    }
  }

  @override
  void dispose() {
    _service?.dispose();
    super.dispose();
  }

  void _retry() {
    final ApiEndpoint? endpoint = _endpoint;
    final int? id = widget.id;
    if (endpoint == null || id == null) return;
    setState(() {
      _future = _service!.fetchDetail(endpoint, id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ApiEndpoint? endpoint = _endpoint;
    final int? id = widget.id;

    if (endpoint == null || id == null) {
      return const NotFoundView(
        message: 'El registro solicitado no existe o la ruta no es válida.',
      );
    }

    final CatalogItem? item = _item;

    return Scaffold(
      appBar: AppBar(title: Text(endpoint.title)),
      body: item != null
          ? _DetailContent(endpoint: endpoint, item: item)
          : AsyncStateView<CatalogItem>(
              future: _future!,
              onRetry: _retry,
              loadingMessage: 'Cargando el detalle del registro...',
              builder: (BuildContext context, CatalogItem data) =>
                  _DetailContent(endpoint: endpoint, item: data),
            ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.endpoint, required this.item});

  final ApiEndpoint endpoint;
  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    final bool hasDescription = item.description.trim().isNotEmpty;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      children: <Widget>[
        _DetailBanner(endpoint: endpoint, item: item),
        const SizedBox(height: 18),
        Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Icon(endpoint.icon, size: 16, color: endpoint.color),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                item.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: endpoint.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (hasDescription) ...<Widget>[
          const SizedBox(height: 24),
          SectionTitle(title: 'Descripción', color: endpoint.color),
          const SizedBox(height: 10),
          Text(item.description, style: Theme.of(context).textTheme.bodyMedium),
        ],
        const SizedBox(height: 24),
        SectionTitle(title: 'Información del registro', color: endpoint.color),
        const SizedBox(height: 12),
        if (item.detailFields.isEmpty)
          Text(
            'Este recurso no tiene campos adicionales.',
            style: Theme.of(context).textTheme.bodySmall,
          )
        else
          ...item.detailFields.map(
            (DetailField field) => DetailInfoTile(field: field),
          ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: endpoint.color.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: endpoint.color.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.code_rounded, size: 18, color: endpoint.color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'GET /api/v1/${endpoint.apiPath}/${item.id}',
                  style: TextStyle(
                    color: endpoint.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailBanner extends StatelessWidget {
  const _DetailBanner({required this.endpoint, required this.item});

  final ApiEndpoint endpoint;
  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = item.imageUrl != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: hasImage ? 210 : 130,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AppNetworkImage(
              url: item.imageUrl,
              fallbackIcon: endpoint.icon,
              fallbackColor: endpoint.color,
            ),
            if (hasImage)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(endpoint.icon, size: 13, color: endpoint.color),
                    const SizedBox(width: 5),
                    Text(
                      endpoint.title,
                      style: TextStyle(
                        color: endpoint.color,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
