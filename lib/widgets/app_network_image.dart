import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

/// Imagen de red con estado de carga y respaldo visual.
///
/// Algunas URLs de la API contienen espacios; se codifican antes de pedir la
/// imagen y, si falla, se muestra un contenedor con un icono.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image_outlined,
    this.fallbackColor = AppColors.blue,
  });

  final String? url;
  final BoxFit fit;
  final IconData fallbackIcon;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    final String? safeUrl = _sanitize(url);
    if (safeUrl == null) return _fallback();

    return Image.network(
      safeUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: fallbackColor.withValues(alpha: 0.06),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        );
      },
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            fallbackColor.withValues(alpha: 0.16),
            fallbackColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        fallbackIcon,
        size: 56,
        color: fallbackColor.withValues(alpha: 0.75),
      ),
    );
  }

  String? _sanitize(String? raw) {
    final String? value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    final String encoded = value.replaceAll(' ', '%20');
    final Uri? uri = Uri.tryParse(encoded);
    if (uri == null || !uri.hasScheme) return null;
    return uri.toString();
  }
}
