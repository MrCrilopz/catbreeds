import 'package:bloc_test/bloc_test.dart';
import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/domain/repositories/breed_repository.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final siberian = _breed('sibe', 'Siberian');
  final abyssinian = _breed('abys', 'Abyssinian');

  blocTest<BreedsBloc, BreedsState>(
    'cargar con éxito deja el catálogo visible',
    build: () => BreedsBloc(
      _CatalogRepository([
        [siberian, abyssinian],
      ]),
    ),
    act: (bloc) => bloc.add(const BreedsRequested()),
    expect: () => [
      const BreedsLoading(),
      BreedsReady(
        catalog: [siberian, abyssinian],
        query: '',
        visible: [siberian, abyssinian],
      ),
    ],
  );

  blocTest<BreedsBloc, BreedsState>(
    'un fallo de red reemplaza la carga',
    build: () => BreedsBloc(_FailingRepository(Failure.network)),
    act: (bloc) => bloc.add(const BreedsRequested()),
    expect: () => [const BreedsLoading(), const BreedsFailure(Failure.network)],
  );

  late _CatalogRepository repository;

  blocTest<BreedsBloc, BreedsState>(
    'la búsqueda reduce las visibles sin otra petición',
    setUp: () => repository = _CatalogRepository([
      [siberian, abyssinian],
    ]),
    build: () => BreedsBloc(repository),
    seed: () => BreedsReady(
      catalog: [siberian, abyssinian],
      query: '',
      visible: [siberian, abyssinian],
    ),
    act: (bloc) => bloc.add(const BreedQueryChanged('sib')),
    expect: () => [
      BreedsReady(
        catalog: [siberian, abyssinian],
        query: 'sib',
        visible: [siberian],
      ),
    ],
    verify: (_) => expect(repository.fetches, 0),
  );

  blocTest<BreedsBloc, BreedsState>(
    'limpiar la búsqueda devuelve el catálogo',
    build: () => BreedsBloc(_CatalogRepository(const [])),
    seed: () => BreedsReady(
      catalog: [siberian, abyssinian],
      query: 'sib',
      visible: [siberian],
    ),
    act: (bloc) => bloc.add(const BreedQueryChanged('')),
    expect: () => [
      BreedsReady(
        catalog: [siberian, abyssinian],
        query: '',
        visible: [siberian, abyssinian],
      ),
    ],
  );

  blocTest<BreedsBloc, BreedsState>(
    'un refresco sustituye la lista y conserva el texto',
    build: () => BreedsBloc(
      _CatalogRepository([
        [siberian, abyssinian],
      ]),
    ),
    seed: () =>
        BreedsReady(catalog: [abyssinian], query: 'sib', visible: const []),
    act: (bloc) => bloc.add(const BreedsRequested()),
    expect: () => [
      const BreedsLoading(),
      BreedsReady(
        catalog: [siberian, abyssinian],
        query: 'sib',
        visible: [siberian],
      ),
    ],
  );

  blocTest<BreedsBloc, BreedsState>(
    'ignora la búsqueda si el catálogo aún no está',
    build: () => BreedsBloc(_CatalogRepository(const [])),
    act: (bloc) => bloc.add(const BreedQueryChanged('sib')),
    expect: () => const <BreedsState>[],
  );
}

final class _CatalogRepository implements BreedRepository {
  _CatalogRepository(this.pages);

  final List<List<Breed>> pages;
  var fetches = 0;

  @override
  Future<List<Breed>> fetchBreeds() async {
    final page = pages[fetches];
    fetches += 1;
    return page;
  }

  @override
  Breed findById(String id) {
    throw Failure.notFound;
  }
}

final class _FailingRepository implements BreedRepository {
  _FailingRepository(this.failure);

  final Failure failure;

  @override
  Future<List<Breed>> fetchBreeds() async {
    throw failure;
  }

  @override
  Breed findById(String id) {
    throw Failure.notFound;
  }
}

Breed _breed(String id, String name) {
  return Breed(
    id: id,
    name: name,
    origin: 'Unknown',
    description: 'A cat.',
    lifeSpan: '12 - 15',
  );
}
