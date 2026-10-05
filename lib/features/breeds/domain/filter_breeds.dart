import 'package:catbreeds/features/breeds/domain/entities/breed.dart';

List<Breed> filterBreeds(List<Breed> breeds, String query) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) {
    return breeds;
  }

  return [
    for (final breed in breeds)
      if (breed.name.toLowerCase().contains(needle)) breed,
  ];
}
