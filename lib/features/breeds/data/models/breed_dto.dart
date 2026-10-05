final class BreedDto {
  const BreedDto({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
    required this.intelligence,
    required this.adaptability,
    required this.lifeSpan,
    required this.imageUrl,
    required this.referenceImageId,
  });

  factory BreedDto.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    return BreedDto(
      id: _string(json['id']),
      name: _string(json['name']),
      origin: _string(json['origin']),
      description: _string(json['description']),
      intelligence: _int(json['intelligence']),
      adaptability: _int(json['adaptability']),
      lifeSpan: _string(json['life_span']),
      imageUrl: image is Map ? _string(image['url']) : null,
      referenceImageId: _string(json['reference_image_id']),
    );
  }

  final String? id;
  final String? name;
  final String? origin;
  final String? description;
  final int? intelligence;
  final int? adaptability;
  final String? lifeSpan;
  final String? imageUrl;
  final String? referenceImageId;
}

String? _string(Object? value) => value is String ? value : null;

int? _int(Object? value) => value is int ? value : null;
