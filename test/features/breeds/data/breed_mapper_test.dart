import 'package:catbreeds/core/error/failure.dart';
import 'package:catbreeds/features/breeds/data/mappers/breed_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('usa la url de la foto cuando viene en el JSON', () {
    final breed = mapBreeds([
      _breed(imageUrl: 'https://cdn2.thecatapi.com/images/sibe.jpg'),
    ]).single;

    expect(breed.imageUrl, 'https://cdn2.thecatapi.com/images/sibe.jpg');
  });

  test('arma la foto con el id de respaldo', () {
    final breed = mapBreeds([
      _breed(imageUrl: null, referenceImageId: '0XYvRd7oD'),
    ]).single;

    expect(breed.imageUrl, 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg');
  });

  test('deja la foto vacía si no hay url ni id de respaldo', () {
    final breed = mapBreeds([
      _breed(imageUrl: null, referenceImageId: null),
    ]).single;

    expect(breed.imageUrl, isNull);
  });

  test('acepta una descripción vacía o ausente', () {
    expect(mapBreeds([_breed(description: '')]).single.description, isEmpty);
    expect(mapBreeds([_breed(description: null)]).single.description, isEmpty);
  });

  test('rechaza un tipo inesperado o un catálogo vacío', () {
    expect(
      () => mapBreeds([_breed(intelligence: 'alta')]),
      throwsA(Failure.unexpected),
    );
    expect(() => mapBreeds(const []), throwsA(Failure.unexpected));
    expect(() => mapBreeds(null), throwsA(Failure.unexpected));
  });
}

Map<String, dynamic> _breed({
  Object? description = 'A fluffy cat.',
  Object? intelligence = 5,
  Object? adaptability = 5,
  Object? imageUrl = 'https://cdn2.thecatapi.com/images/sibe.jpg',
  Object? referenceImageId = 'sibe',
}) {
  return {
    'id': 'sibe',
    'name': 'Siberian',
    'origin': 'Russia',
    'life_span': '12 - 15',
    'intelligence': intelligence,
    'adaptability': adaptability,
    'description': ?description,
    'reference_image_id': ?referenceImageId,
    if (imageUrl != null) 'image': {'url': imageUrl},
  };
}
