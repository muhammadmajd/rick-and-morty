
import '../entities/character.dart';
import '../entities/character_detail.dart';
import '../entities/location.dart';
import '../entities/episode.dart';
import '../entities/pagination_info.dart';

abstract class CharacterRepository {

  Future<(PaginationInfo?, List<Character>)> getCharacters({
    int page = 1,
    String? nameFilter,
  });

  Future<Character> getCharacterById(String id);
  Future<List<Character>> getCharactersByIds(List<String> ids);

  /// New methods for detailed views
  Future<CharacterDetail> getCharacterDetail(String id);
  Future<Location> getLocationDetail(String id); // Add this method
  Future<List<Episode>> getEpisodesByIds(List<String> ids);

  /// Favorite methods
  Future<void> addToFavorites(Character character);
  Future<void> removeFromFavorites(String characterId);
  Future<List<Character>> getFavoriteCharacters();
  Future<bool> isFavorite(String characterId);
}