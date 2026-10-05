import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/domain/filter_breeds.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final breeds = [
    _breed(id: 'sibe', name: 'Siberian'),
    _breed(id: 'siam', name: 'Siamese', origin: 'Thailand'),
    _breed(id: 'abys', name: 'Abyssinian'),
  ];

  test('una consulta vacía o en blanco devuelve el catálogo en el mismo orden', () {
    expect(filterBreeds(breeds, ''), breeds);
    expect(filterBreeds(breeds, '   '), breeds);
  });

  test('compara el nombre sin distinguir mayúsculas', () {
    expect(filterBreeds(breeds, 'SIB'), [breeds.first]);
  });

  test('recorta espacios y no usa el país ni la descripción', () {
    expect(filterBreeds(breeds, '  siam '), [breeds[1]]);
    expect(filterBreeds(breeds, 'thailand'), isEmpty);
  });

  test('sin coincidencias devuelve una lista vacía', () {
    expect(filterBreeds(breeds, 'xyz'), isEmpty);
  });

  test('no reordena las coincidencias', () {
    final catalog = [
      _breed(id: 'bali', name: 'Balinese'),
      _breed(id: 'bamb', name: 'Bambino'),
      _breed(id: 'abys', name: 'Abyssinian'),
    ];

    expect(
      filterBreeds(catalog, 'ba').map((breed) => breed.id),
      ['bali', 'bamb'],
    );
  });
}

Breed _breed({
  required String id,
  required String name,
  String origin = 'Russia',
}) {
  return Breed(
    id: id,
    name: name,
    origin: origin,
    description: 'A calm cat.',
    intelligence: 5,
    adaptability: 4,
    lifeSpan: '12 - 15',
  );
}
