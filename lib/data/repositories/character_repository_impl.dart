
import '../../domain/repositories/character_repository.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/character_detail.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/episode.dart';
import '../../domain/entities/pagination_info.dart';
import '../datasources/character_remote_data_source.dart';
import '../datasources/favorite_local_data_source.dart';
import '../models/favorite_hive_model.dart';



class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final FavoriteLocalDataSource favoriteLocalDataSource;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.favoriteLocalDataSource,
  });

  @override
  Future<(PaginationInfo?, List<Character>)> getCharacters({
    int page = 1,
    String? nameFilter,
  }) async {
    final (paginationInfo, characters) = await remoteDataSource.getCharacters(
      page: page,
      nameFilter: nameFilter,
    );

    // Update characters with favorite status - handle async
    final charactersWithFavorites = await Future.wait(
      characters.map((character) async {
        final isFavorite = await favoriteLocalDataSource.isFavorite(character.id);
        return character.copyWith(isFavorite: isFavorite);
      }),
    );

    return (paginationInfo, charactersWithFavorites);
  }

  /// favorite methods
  @override
  Future<void> addToFavorites(Character character) async {
    final favorite = FavoriteHiveModel(
      characterId: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      type: character.type,
      gender: character.gender,
      image: character.image,
      addedAt: DateTime.now(),
    );

    await favoriteLocalDataSource.addFavorite(favorite);
  }
 @override
  Future<void> removeFromFavorites(String characterId) async {
    await favoriteLocalDataSource.removeFavorite(characterId);
  }

  @override
  Future<List<Character>> getFavoriteCharacters() async {
    final favorites = await favoriteLocalDataSource.getAllFavorites();

    return favorites.map((favorite) => Character(
      id: favorite.characterId,
      name: favorite.name,
      status: favorite.status,
      species: favorite.species,
      type: favorite.type,
      gender: favorite.gender,
      image: favorite.image,
      origin: null,
      location: null,
      episodes: [],
      isFavorite: true,
    )).toList();
  }
  /// Is character favorite?
  @override
  Future<bool> isFavorite(String characterId) async {
    return await favoriteLocalDataSource.isFavorite(characterId);
  }


  @override
  Future<Character> getCharacterById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Character>> getCharactersByIds(List<String> ids) {

    throw UnimplementedError();
  }
 /// get Character's Details by id
  @override
  Future<CharacterDetail> getCharacterDetail(String id) async {
    final characterDetail = await remoteDataSource.getCharacterDetail(id);
    return characterDetail;
  }

  @override
  Future<Location> getLocationDetail(String id) async { // Implement this method
    final location = await remoteDataSource.getLocationDetail(id);
    return location;
  }

  @override
  Future<List<Episode>> getEpisodesByIds(List<String> ids) async {
    final episodes = await remoteDataSource.getEpisodesByIds(ids);
    return episodes;
  }
}