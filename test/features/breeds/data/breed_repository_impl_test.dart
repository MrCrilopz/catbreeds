import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/data/datasources/breed_remote_data_source.dart';
import 'package:catbreeds/features/breeds/data/repositories/breed_repository_impl.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('guarda el catálogo y un refresco lo sustituye', () async {
    final remote = _FakeRemote([
      [_breed('sibe')],
      [_breed('siam')],
    ]);
    final repository = BreedRepositoryImpl(remote);

    expect(() => repository.findById('sibe'), throwsA(Failure.notFound));

    await repository.fetchBreeds();
    expect(repository.findById('sibe').name, 'Siberian');

    await repository.fetchBreeds();
    expect(repository.findById('siam').name, 'Siamese');
    expect(() => repository.findById('sibe'), throwsA(Failure.notFound));
  });

  test('traduce los fallos de Dio', () {
    final options = RequestOptions(path: '/v1/breeds');

    expect(
      failureFromDio(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionTimeout,
        ),
      ),
      Failure.network,
    );
    expect(
      failureFromDio(
        DioException(
          requestOptions: options,
          type: DioExceptionType.receiveTimeout,
        ),
      ),
      Failure.network,
    );
    expect(
      failureFromDio(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
        ),
      ),
      Failure.server,
    );
    expect(
      failureFromDio(
        DioException(requestOptions: options, type: DioExceptionType.unknown),
      ),
      Failure.unexpected,
    );
  });
}

final class _FakeRemote implements BreedRemoteDataSource {
  _FakeRemote(this._pages);

  final List<List<Breed>> _pages;
  var _index = 0;

  @override
  Future<List<Breed>> fetchBreeds() async {
    final page = _pages[_index];
    if (_index < _pages.length - 1) {
      _index += 1;
    }
    return page;
  }
}

Breed _breed(String id) {
  return Breed(
    id: id,
    name: id == 'sibe' ? 'Siberian' : 'Siamese',
    origin: 'Russia',
    description: 'A fluffy cat.',
    intelligence: 5,
    adaptability: 4,
    lifeSpan: '12 - 15',
  );
}
