import 'package:catbreeds/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el arranque muestra el título y sigue el tema del sistema', (
    tester,
  ) async {
    await tester.pumpWidget(const CatbreedsApp());

    expect(find.text('Catbreeds'), findsOneWidget);
    expect(
      find.textContaining('Falta la clave de The Cat API'),
      findsOneWidget,
    );

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.system);
    expect(app.theme?.colorScheme.primary, const Color(0xFFC85A32));
    expect(app.theme?.scaffoldBackgroundColor, const Color(0xFFF9F6F0));
    expect(app.darkTheme?.colorScheme.primary, const Color(0xFFE39274));
    expect(app.darkTheme?.scaffoldBackgroundColor, const Color(0xFF1A1410));
  });
}
