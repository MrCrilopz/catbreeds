import 'package:catbreeds/features/breeds/domain/entities/breed.dart';

abstract interface class BreedRepository {
  Future<List<Breed>> fetchBreeds();

  Breed findById(String id);
}
