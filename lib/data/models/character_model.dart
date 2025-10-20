
import 'package:flutter/foundation.dart';
import '../../domain/entities/character.dart';

class CharacterModel extends Character {
  CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.image,
    super.origin,
    super.location,
    required super.episodes,
    bool? isFavorite
  }) : super(
    isFavorite: isFavorite!
  );

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse episodes
      final episodes = <String>[];
      final episodeList = json['episode'];
      if (episodeList is List) {
        for (var episode in episodeList) {
          if (episode is Map) {
            final id = episode['id'];
            if (id != null) {
              episodes.add(id.toString());
            }
          }
        }
      }

      // Parse origin
      String? originName;
      final originData = json['origin'];
      if (originData is Map) {
        originName = originData['name']?.toString();
      }

      // Parse location
      String? locationName;
      final locationData = json['location'];
      if (locationData is Map) {
        locationName = locationData['name']?.toString();
      }

      // Generate ID if missing (fallback)
      String characterId;
      if (json['id'] != null) {
        characterId = json['id'].toString();
      } else {
        // Fallback: generate ID from image URL or use timestamp
        final imageUrl = json['image']?.toString() ?? '';
        if (imageUrl.isNotEmpty) {
          final match = RegExp(r'character/avatar/(\d+)').firstMatch(imageUrl);
          characterId = match?.group(1) ?? '${DateTime.now().millisecondsSinceEpoch}';
        } else {
          characterId = '${DateTime.now().millisecondsSinceEpoch}';
        }
      }

      return CharacterModel(
        id: characterId,
        name: json['name']?.toString() ?? 'Unknown',
        status: json['status']?.toString() ?? 'Unknown',
        species: json['species']?.toString() ?? 'Unknown',
        type: json['type']?.toString() ?? '',
        gender: json['gender']?.toString() ?? 'Unknown',
        image: json['image']?.toString() ?? '',
        origin: originName,
        location: locationName,
        episodes: episodes,
        isFavorite: false, // Default to false, will be updated from local storage
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('=== ERROR in CharacterModel.fromJson ===');

        print('Error: $e');
        print('Stack trace: $stackTrace');
      }
      // Return default character
      return CharacterModel(
        id: 'error-${DateTime.now().millisecondsSinceEpoch}',
        name: json['name']?.toString() ?? 'Error Character',
        status: 'Unknown',
        species: 'Unknown',
        type: '',
        gender: 'Unknown',
        image: '',
        origin: null,
        location: null,
        episodes: [],
      );
    }
  }
}