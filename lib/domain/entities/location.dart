
import 'character.dart';

class Location {
  final String id;
  final String name;
  final String type;
  final String dimension;
  final List<Character> residents;
  final String created;

  Location({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.created,
  });
}