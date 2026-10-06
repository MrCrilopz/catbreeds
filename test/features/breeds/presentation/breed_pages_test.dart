import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/core/theme/app_theme.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/domain/repositories/breed_repository.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_state.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breed_detail_page.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breed_list_page.dart';
import 'package:catbreeds/features/breeds/presentation/pages/splash_page.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_card.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/fact_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final siberian = Breed(
    id: 'sibe',
    name: 'Siberian',
    origin: 'Russia',
    description: 'A fluffy cat with a long description for the detail.',
    lifeSpan: '12 - 15',
    temperament: 'Active, Energetic',
    breedGroup: 'Longhair',
    weight: '3-7',
    height: '23-28',
  );

  testWidgets('la tarjeta muestra nombre, país, peso y temperamento', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ListView(
            children: [BreedCard(breed: siberian, onOpen: () {})],
          ),
        ),
      ),
    );

    expect(find.text('Siberian'), findsOneWidget);
    expect(find.text('Russia'), findsOneWidget);
    expect(find.text('12 - 15 years'), findsOneWidget);
    expect(find.text('Longhair'), findsWidgets);
    expect(find.text('3-7 kg'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Energetic'), findsOneWidget);
    expect(find.text('See details'), findsOneWidget);
    expect(find.textContaining('fluffy'), findsOneWidget);
  });

  testWidgets('la búsqueda sin coincidencias cita el texto', (tester) async {
    final bloc = BreedsBloc(
      _Repository([
        [siberian],
      ]),
    );
    addTearDown(bloc.close);
    await tester.pumpWidget(_app(bloc, const BreedListPage()));
    bloc.add(const BreedsRequested());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();

    expect(find.text('No breed matches "zzz".'), findsOneWidget);
  });

  testWidgets('el error ofrece reintentar', (tester) async {
    final bloc = BreedsBloc(
      _Repository([
        Failure.network,
        [siberian],
      ]),
    );
    addTearDown(bloc.close);
    await tester.pumpWidget(_app(bloc, const BreedListPage()));
    bloc.add(const BreedsRequested());
    await tester.pumpAndSettle();

    expect(
      find.text(
        'We couldn\'t load the breeds. Check your connection and try again.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Siberian'), findsOneWidget);
  });

  testWidgets('la foto del detalle queda fuera del scroll', (tester) async {
    final bloc = BreedsBloc(
      _Repository([
        [siberian],
      ]),
    );
    addTearDown(bloc.close);
    bloc.add(const BreedsRequested());
    await bloc.stream.firstWhere((state) => state is BreedsReady);

    await tester.pumpWidget(_app(bloc, const BreedDetailPage(id: 'sibe')));
    await tester.pumpAndSettle();

    final scrollable = find.byType(Scrollable);
    final missingPhoto = find.bySemanticsLabel('No photo');
    expect(missingPhoto, findsOneWidget);
    expect(
      find.descendant(of: scrollable, matching: missingPhoto),
      findsNothing,
    );
    expect(
      find.descendant(
        of: scrollable,
        matching: find.text(
          'A fluffy cat with a long description for the detail.',
        ),
      ),
      findsOneWidget,
    );
    expect(find.text('12 - 15 years'), findsOneWidget);
    expect(find.text('Russia'), findsOneWidget);
    expect(find.text('Lifespan'), findsOneWidget);
    expect(find.text('3-7 kg'), findsOneWidget);
    expect(find.text('Temperament'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('History'), findsNothing);
  });

  testWidgets('en el ancho del teléfono los datos cortos comparten fila', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: 328, child: FactGrid(breed: siberian)),
          ),
        ),
      ),
    );

    final origin = tester.getTopLeft(find.text('Lifespan'));
    final life = tester.getTopLeft(find.text('Weight'));
    final weight = tester.getTopLeft(find.text('Height'));
    final height = tester.getTopLeft(find.text('Coat'));
    expect(origin.dy, life.dy);
    expect(origin.dx, lessThan(life.dx));
    expect(weight.dy, height.dy);
    expect(weight.dx, lessThan(height.dx));
  });

  testWidgets('volver del detalle no deja el buscador enfocado', (
    tester,
  ) async {
    final bloc = BreedsBloc(
      _Repository([
        [siberian],
      ]),
    );
    addTearDown(bloc.close);
    bloc.add(const BreedsRequested());
    await bloc.stream.firstWhere((state) => state is BreedsReady);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: MaterialApp(
          theme: AppTheme.light,
          navigatorObservers: [breedRoutes],
          initialRoute: BreedListPage.route,
          onGenerateRoute: (settings) {
            final page = switch (settings.name) {
              BreedDetailPage.route => BreedDetailPage(
                id: settings.arguments is String
                    ? settings.arguments! as String
                    : '',
              ),
              _ => const BreedListPage(),
            };
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => page,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Siberian'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isFalse,
    );
  });

  testWidgets('la tarjeta omite lo que no llega', (tester) async {
    const bare = Breed(
      id: 'bare',
      name: 'Bare',
      origin: '',
      description: '',
      lifeSpan: '',
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: ListView(
            children: [BreedCard(breed: bare, onOpen: () {})],
          ),
        ),
      ),
    );

    expect(find.text('Bare'), findsOneWidget);
    expect(find.text('See details'), findsOneWidget);
    expect(find.text('Temperament'), findsNothing);
    expect(find.textContaining('years'), findsNothing);
    expect(find.textContaining('kg'), findsNothing);
  });

  testWidgets('la tarjeta deja los rasgos de más en puntos suspensivos', (
    tester,
  ) async {
    final breed = Breed(
      id: 'abys',
      name: 'Abyssinian',
      origin: 'Egypt',
      description: 'Medium-sized.',
      lifeSpan: '14-17',
      temperament: 'Active, Energetic, Independent, Intelligent, Gentle, Curious, Playful',
      breedGroup: 'Short-haired',
      weight: '3.6-5.4',
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 328,
              child: BreedCard(breed: breed, onOpen: () {}),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Active'), findsOneWidget);
    expect(find.text('…'), findsOneWidget);
    expect(find.text('Playful'), findsNothing);
  });

  testWidgets('el inicio espera un segundo antes de la lista', (tester) async {
    final bloc = BreedsBloc(
      _Repository([
        [siberian],
      ]),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(_app(bloc, const SplashPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Discovering breeds'), findsOneWidget);
    expect(find.byType(BreedListPage), findsNothing);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.byType(BreedListPage), findsOneWidget);
  });
}

Widget _app(BreedsBloc bloc, Widget home) {
  return BlocProvider.value(
    value: bloc,
    child: MaterialApp(theme: AppTheme.light, home: home),
  );
}

final class _Repository implements BreedRepository {
  _Repository(this.steps);

  final List<Object> steps;
  var index = 0;

  @override
  Future<List<Breed>> fetchBreeds() async {
    final step = steps[index];
    if (index < steps.length - 1) {
      index += 1;
    }
    if (step is Failure) {
      throw step;
    }
    return step as List<Breed>;
  }

  @override
  Breed findById(String id) {
    throw Failure.notFound;
  }
}
