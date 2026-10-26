import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/async_state_view.dart';

/// Pantalla para rutas inexistentes o parámetros inválidos.
class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta no encontrada')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: EmptyState(
                icon: Icons.explore_off_outlined,
                title: 'No encontramos esta página',
                message:
                    message ??
                    'La ruta que intentas abrir no existe o ya no está '
                        'disponible.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_outlined, size: 18),
                  label: const Text('Volver al inicio'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
