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
    final breed = mapBreeds([_breed(imageUrl: null, referenceImageId: null)])
        .single;

    expect(breed.imageUrl, isNull);
  });

  test('toma temperamento, pelaje, peso y altura del JSON', () {
    final breed = mapBreeds([
      {
        'id': 'abys',
        'name': 'Abyssinian',
        'origin': 'Egypt',
        'life_span': '14-17',
        'temperament': 'Active, Energetic',
        'breed_group': 'Short-haired',
        'description': 'Active.',
        'history': 'An old breed.',
        'country_code': 'EG',
        'weight': {'metric': '3.6-5.4'},
        'height': {'metric': '25-30'},
      },
    ]).single;

    expect(breed.temperament, 'Active, Energetic');
    expect(breed.breedGroup, 'Short-haired');
    expect(breed.weight, '3.6-5.4');
    expect(breed.height, '25-30');
    expect(breed.history, 'An old breed.');
    expect(breed.countryCode, 'EG');
  });

  test('acepta una descripción vacía o ausente', () {
    expect(mapBreeds([_breed(description: '')]).single.description, isEmpty);
    expect(mapBreeds([_breed(description: null)]).single.description, isEmpty);
  });

  test('rechaza un tipo inesperado o un catálogo vacío', () {
    expect(() => mapBreeds([_breed(name: 1)]), throwsA(Failure.unexpected));
    expect(() => mapBreeds(const []), throwsA(Failure.unexpected));
    expect(() => mapBreeds(null), throwsA(Failure.unexpected));
  });
}

Map<String, dynamic> _breed({
  Object? name = 'Siberian',
  Object? description = 'A fluffy cat.',
  Object? imageUrl = 'https://cdn2.thecatapi.com/images/sibe.jpg',
  Object? referenceImageId = 'sibe',
}) {
  return {
    'id': 'sibe',
    'name': ?name,
    'origin': 'Russia',
    'life_span': '12 - 15',
    'temperament': 'Active',
    'breed_group': 'Longhair',
    'weight': {'metric': '3-7'},
    'description': ?description,
    'reference_image_id': ?referenceImageId,
    if (imageUrl != null) 'image': {'url': imageUrl},
  };
}
