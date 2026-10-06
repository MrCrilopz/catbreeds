final class Breed {
  const Breed({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
    required this.lifeSpan,
    this.temperament = '',
    this.breedGroup = '',
    this.weight = '',
    this.height = '',
    this.history = '',
    this.countryCode = '',
    this.imageUrl,
  });

  final String id;
  final String name;
  final String origin;
  final String description;
  final String lifeSpan;
  final String temperament;
  final String breedGroup;
  final String weight;
  final String height;
  final String history;
  final String countryCode;
  final String? imageUrl;

  @override
  bool operator ==(Object other) {
    return other is Breed &&
        other.id == id &&
        other.name == name &&
        other.origin == origin &&
        other.description == description &&
        other.lifeSpan == lifeSpan &&
        other.temperament == temperament &&
        other.breedGroup == breedGroup &&
        other.weight == weight &&
        other.height == height &&
        other.history == history &&
        other.countryCode == countryCode &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    origin,
    description,
    lifeSpan,
    temperament,
    breedGroup,
    weight,
    height,
    history,
    countryCode,
    imageUrl,
  );
}
