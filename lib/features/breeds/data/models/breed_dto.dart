final class BreedDto {
  const BreedDto({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
    required this.lifeSpan,
    required this.temperament,
    required this.breedGroup,
    required this.weight,
    required this.height,
    required this.history,
    required this.countryCode,
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
      lifeSpan: _string(json['life_span']),
      temperament: _string(json['temperament']),
      breedGroup: _string(json['breed_group']),
      weight: _metric(json['weight']),
      height: _metric(json['height']),
      history: _string(json['history']),
      countryCode: _string(json['country_code']),
      imageUrl: image is Map ? _string(image['url']) : null,
      referenceImageId: _string(json['reference_image_id']),
    );
  }

  final String? id;
  final String? name;
  final String? origin;
  final String? description;
  final String? lifeSpan;
  final String? temperament;
  final String? breedGroup;
  final String? weight;
  final String? height;
  final String? history;
  final String? countryCode;
  final String? imageUrl;
  final String? referenceImageId;
}

String? _string(Object? value) => value is String ? value : null;

String? _metric(Object? value) {
  if (value is! Map) {
    return null;
  }
  final metric = value['metric'];
  return metric is String ? metric : null;
}
