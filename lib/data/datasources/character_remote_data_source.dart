
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/network/GraphQLClientService.dart';
import '../graphql/character_queries.dart';
import '../models/CharacterDetailModel.dart';
import '../models/character_model.dart';
import '../models/episode_model.dart';
import '../models/location_model.dart';
import '../models/pagination_info_model.dart';

class CharacterRemoteDataSource {
  final GraphQLClient _client;

  CharacterRemoteDataSource() : _client = GraphQLClientService.getClient();



  Future<(PaginationInfoModel?, List<CharacterModel>)> getCharacters({
    int page = 1,
    String? nameFilter,
  }) async {
    try {
      final Map<String, dynamic> variables = {'page': page};

      if (nameFilter != null && nameFilter.isNotEmpty) {
        variables['filter'] = {'name': nameFilter};
      }


      final QueryResult result = await _client.query(
        QueryOptions(
          document: gql(CharacterQueries.getCharacters),
          variables: variables,
        ),
      );


      if (result.hasException) {

        throw Exception(result.exception.toString());
      }

      final data = result.data?['characters'];
      if (data == null) {
        if (kDebugMode) {
          print('=== NO CHARACTERS DATA ===');
        }
        return (null, <CharacterModel>[]);
      }


      final PaginationInfoModel? info = data['info'] != null
          ? PaginationInfoModel.fromJson(data['info'])
          : null;


      final List<CharacterModel> results = (data['results'] as List? ?? [])
          .map<CharacterModel?>((characterData) {
        try {
          if (characterData == null) return null;
          return CharacterModel.fromJson(characterData);
        } catch (e, stackTrace) {
          if (kDebugMode) {
            print('=== ERROR PARSING CHARACTER ===');
            print('Character data: $characterData');
            print('Error: $e');
            print('Stack trace: $stackTrace');
          }
          return null;
        }
      })
          .where((character) => character != null)
          .cast<CharacterModel>()
          .toList();

      if (kDebugMode) {
        print('=== PARSING COMPLETE ===');
        print('Successfully parsed ${results.length} characters');
      }

      return (info, results);
    } catch (e) {
      if (kDebugMode) {
        print('=== ERROR IN getCharacters ===');
        print('Error: $e');
        print('Stack trace: ${e}');
      }
      throw Exception('Failed to load characters: $e');
    }
  }

  /// get Character's Detail
  Future<CharacterDetailModel> getCharacterDetail(String id) async {
    try {
      final QueryResult result = await _client.query(
        QueryOptions(
          document: gql(CharacterQueries.getCharacterById),
          variables: {'id': id},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data?['character'];
      if (data == null) {
        throw Exception('Character not found');
      }

      return CharacterDetailModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load character details: $e');
    }
  }
  /// get Location's Detail
  Future<LocationModel> getLocationDetail(String id) async {
    try {
      final QueryResult result = await _client.query(
        QueryOptions(
          document: gql(CharacterQueries.getLocationById),
          variables: {'id': id},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data?['location'];
      if (data == null) {
        throw Exception('Location not found');
      }

      return LocationModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load location details: $e');
    }
  }
  /// get Episode's Detail
  Future<List<EpisodeModel>> getEpisodesByIds(List<String> ids) async {
    try {
      final QueryResult result = await _client.query(
        QueryOptions(
          document: gql(CharacterQueries.getEpisodesByIds),
          variables: {'ids': ids},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data?['episodesByIds'] as List? ?? [];
      return data.map((episodeData) => EpisodeModel.fromJson(episodeData)).toList();
    } catch (e) {
      throw Exception('Failed to load episodes: $e');
    }
  }
}