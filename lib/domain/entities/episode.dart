
import 'character.dart';

class Episode {
  final String id;
  final String name;
  final String airDate;
  final String episode;
  final List<Character> characters;
  final String created;

  Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
    required this.characters,
    required this.created,
  });
}