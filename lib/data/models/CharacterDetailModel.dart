
import 'package:flutter/foundation.dart';
import '../../domain/entities/character_detail.dart';
import 'episode_model.dart';
import 'location_model.dart';

class CharacterDetailModel extends CharacterDetail {
  CharacterDetailModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.image,
    required super.created,
    LocationModel? super.origin,
    LocationModel? super.location,
    required List<EpisodeModel> super.episodes,
  });

  factory CharacterDetailModel.fromJson(Map<String, dynamic> json) {
    // Parse origin
    LocationModel? origin;
    if (json['origin'] != null) {
      origin = LocationModel.fromJson(json['origin']);
    }

    // Parse location
    LocationModel? location;
    if (json['location'] != null) {
      location = LocationModel.fromJson(json['location']);
    }

    // Parse episodes
    final List<EpisodeModel> episodes = [];
    if (json['episode'] is List) {
      for (var episodeData in json['episode']) {
        if (episodeData is Map<String, dynamic>) {
          episodes.add(EpisodeModel.fromJson(episodeData));
        }
      }
    }

    return CharacterDetailModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      status: json['status']?.toString() ?? 'Unknown',
      species: json['species']?.toString() ?? 'Unknown',
      type: json['type']?.toString() ?? '',
      gender: json['gender']?.toString() ?? 'Unknown',
      image: json['image']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      origin: origin,
      location: location,
      episodes: episodes,
    );
  }
}