import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/data/datasources/breed_remote_data_source.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/domain/repositories/breed_repository.dart';

final class BreedRepositoryImpl implements BreedRepository {
  BreedRepositoryImpl(this._remote);

  final BreedRemoteDataSource _remote;
  List<Breed>? _catalog;

  @override
  Future<List<Breed>> fetchBreeds() async {
    final breeds = await _remote.fetchBreeds();
    _catalog = breeds;
    return breeds;
  }

  @override
  Breed findById(String id) {
    final catalog = _catalog;
    if (catalog == null) {
      throw Failure.notFound;
    }

    for (final breed in catalog) {
      if (breed.id == id) {
        return breed;
      }
    }

    throw Failure.notFound;
  }
}
