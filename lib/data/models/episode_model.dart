
import '../../domain/entities/episode.dart';
import 'character_model.dart';

class EpisodeModel extends Episode {
  EpisodeModel({
    required super.id,
    required super.name,
    required super.airDate,
    required super.episode,
    required List<CharacterModel> super.characters,
    required super.created,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    // Parse characters
    final List<CharacterModel> characters = [];
    if (json['characters'] is List) {
      for (var characterData in json['characters']) {
        if (characterData is Map<String, dynamic>) {
          characters.add(CharacterModel.fromJson(characterData));
        }
      }
    }

    return EpisodeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      airDate: json['air_date']?.toString() ?? 'Unknown',
      episode: json['episode']?.toString() ?? 'Unknown',
      characters: characters,
      created: json['created']?.toString() ?? '',
    );
  }
}