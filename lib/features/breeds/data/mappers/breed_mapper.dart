import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/data/models/breed_dto.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';

const _imageCdn = 'https://cdn2.thecatapi.com/images';

List<Breed> mapBreeds(Object? data) {
  if (data is! List || data.isEmpty) {
    throw Failure.unexpected;
  }

  return [
    for (final item in data)
      if (item is Map<String, dynamic>)
        mapBreed(BreedDto.fromJson(item))
      else if (item is Map)
        mapBreed(BreedDto.fromJson(Map<String, dynamic>.from(item)))
      else
        throw Failure.unexpected,
  ];
}

Breed mapBreed(BreedDto dto) {
  final id = dto.id;
  final name = dto.name;
  final intelligence = dto.intelligence;
  final adaptability = dto.adaptability;
  if (id == null ||
      id.isEmpty ||
      name == null ||
      name.isEmpty ||
      intelligence == null ||
      adaptability == null) {
    throw Failure.unexpected;
  }

  return Breed(
    id: id,
    name: name,
    origin: dto.origin ?? '',
    description: dto.description ?? '',
    intelligence: intelligence,
    adaptability: adaptability,
    lifeSpan: dto.lifeSpan ?? '',
    imageUrl: _imageUrl(dto),
  );
}

String? _imageUrl(BreedDto dto) {
  final url = dto.imageUrl?.trim();
  if (url != null && url.isNotEmpty) {
    return url;
  }

  final referenceId = dto.referenceImageId?.trim();
  if (referenceId == null || referenceId.isEmpty) {
    return null;
  }

  return '$_imageCdn/$referenceId.jpg';
}
