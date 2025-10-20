
import 'location.dart';
import 'episode.dart';

class CharacterDetail {
  final String id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String created;
  final Location? origin;
  final Location? location;
  final List<Episode> episodes;

  CharacterDetail({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.created,
    this.origin,
    this.location,
    required this.episodes,
  });
}