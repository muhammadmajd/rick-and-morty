
import '../../domain/entities/location.dart';
import 'character_model.dart';

class LocationModel extends Location {
  LocationModel({
    required super.id,
    required super.name,
    required super.type,
    required super.dimension,
    required List<CharacterModel> super.residents,
    required super.created,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    // Parse residents
    final List<CharacterModel> residents = [];
    if (json['residents'] is List) {
      for (var residentData in json['residents']) {
        if (residentData is Map<String, dynamic>) {
          residents.add(CharacterModel.fromJson(residentData));
        }
      }
    }

    return LocationModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      type: json['type']?.toString() ?? 'Unknown',
      dimension: json['dimension']?.toString() ?? 'Unknown',
      residents: residents,
      created: json['created']?.toString() ?? '',
    );
  }
}