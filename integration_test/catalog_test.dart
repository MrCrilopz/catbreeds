import 'package:catbreeds/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('el catálogo real se busca, se abre y vuelve', (tester) async {
    app.main();
    await tester.pump();
    expect(find.textContaining('The Cat API key is missing'), findsNothing);

    await _waitFor(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Abyssinian');
    final open = find.text('See details');
    await _waitFor(tester, open);
    await tester.ensureVisible(open);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(open);
    await _waitFor(tester, find.byTooltip('Back'));
    await tester.scrollUntilVisible(
      find.text('About'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('About'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await _waitFor(tester, find.byType(TextField));
    await tester.pump(const Duration(milliseconds: 600));
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'Abyssinian',
    );

    await tester.tap(find.byType(TextField));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'zzz',
    );
    await _waitFor(tester, find.text('No breed matches "zzz".'));
  });
}

Future<void> _waitFor(WidgetTester tester, Finder finder) async {
  final deadline = DateTime.now().add(const Duration(seconds: 40));
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  expect(finder, findsWidgets);
}
