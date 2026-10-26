import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const ColombiaDataApp());
}

/// Aplicación de datos abiertos de Colombia.
class ColombiaDataApp extends StatelessWidget {
  const ColombiaDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
