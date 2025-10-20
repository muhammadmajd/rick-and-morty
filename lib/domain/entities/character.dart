
class Character {
  final String id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String? origin;
  final String? location;
  final List<String> episodes;
  final bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    this.origin,
    this.location,
    required this.episodes,
    this.isFavorite = false, // Default to false

  });

  /// copyWith method for easy updates
  Character copyWith({
    String? id,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? image,
    String? origin,
    String? location,
    List<String>? episodes,
    bool? isFavorite,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      origin: origin ?? this.origin,
      location: location ?? this.location,
      episodes: episodes ?? this.episodes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}