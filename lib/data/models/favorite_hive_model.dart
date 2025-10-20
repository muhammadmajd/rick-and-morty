
import 'package:hive/hive.dart';

part 'favorite_hive_model.g.dart';

@HiveType(typeId: 4)
class FavoriteHiveModel {
  @HiveField(0)
  final String characterId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String gender;

  @HiveField(6)
  final String image;

  @HiveField(7)
  final DateTime addedAt;

  FavoriteHiveModel({
    required this.characterId,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.addedAt,
  });
}