import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/main.dart';
import 'package:taller_datos_abiertos/widgets/endpoint_card.dart';

void main() {
  testWidgets('El dashboard muestra una tarjeta por endpoint', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const ColombiaDataApp());
    await tester.pumpAndSettle();

    expect(find.byType(EndpointCard), findsNWidgets(7));
    expect(find.text('Departamentos'), findsOneWidget);
    expect(find.text('Presidentes'), findsOneWidget);
    expect(find.text('Platos típicos'), findsOneWidget);
    expect(find.textContaining('Colombia'), findsWidgets);
  });
}
