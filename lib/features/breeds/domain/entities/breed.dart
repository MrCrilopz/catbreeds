final class Breed {
  const Breed({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
    required this.intelligence,
    required this.adaptability,
    required this.lifeSpan,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String origin;
  final String description;
  final int intelligence;
  final int adaptability;
  final String lifeSpan;
  final String? imageUrl;

  @override
  bool operator ==(Object other) {
    return other is Breed &&
        other.id == id &&
        other.name == name &&
        other.origin == origin &&
        other.description == description &&
        other.intelligence == intelligence &&
        other.adaptability == adaptability &&
        other.lifeSpan == lifeSpan &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    origin,
    description,
    intelligence,
    adaptability,
    lifeSpan,
    imageUrl,
  );
}
