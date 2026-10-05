import 'package:catbreeds/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('el arranque muestra el título y sigue el tema del sistema', (tester) async {
    await tester.pumpWidget(const CatbreedsApp());

    expect(find.text('Catbreeds'), findsOneWidget);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.system);
    expect(app.theme?.colorScheme.primary, const Color(0xFF52796F));
    expect(app.theme?.scaffoldBackgroundColor, const Color(0xFFF7F5F0));
    expect(app.darkTheme?.colorScheme.primary, const Color(0xFF8FB8AA));
    expect(app.darkTheme?.scaffoldBackgroundColor, const Color(0xFF161C22));
  });
}
