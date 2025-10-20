
import 'package:hive/hive.dart';
import '../models/favorite_hive_model.dart';

class FavoriteLocalDataSource {
  static const String _favoriteBox = 'favorites';
  Box<FavoriteHiveModel>? _favoriteBoxInstance;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _favoriteBoxInstance = await Hive.openBox<FavoriteHiveModel>(_favoriteBox);
      _isInitialized = true;
    }
  }

  // Ensure the box is initialized before any operation
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  // Add character to favorites
  Future<void> addFavorite(FavoriteHiveModel favorite) async {
    await _ensureInitialized();
    await _favoriteBoxInstance!.put(favorite.characterId, favorite);
  }

  // Remove character from favorites
  Future<void> removeFavorite(String characterId) async {
    await _ensureInitialized();
    await _favoriteBoxInstance!.delete(characterId);
  }

  // Check if character is favorite
  Future<bool> isFavorite(String characterId) async {
    await _ensureInitialized();
    return _favoriteBoxInstance!.containsKey(characterId);
  }

  // Get all favorites
  Future<List<FavoriteHiveModel>> getAllFavorites() async {
    await _ensureInitialized();
    final favorites = _favoriteBoxInstance!.values.toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return favorites;
  }

  // Get favorites count
  Future<int> get favoritesCount async {
    await _ensureInitialized();
    return _favoriteBoxInstance!.length;
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    await _ensureInitialized();
    await _favoriteBoxInstance!.clear();
  }

  // Close the box
  Future<void> close() async {
    if (_isInitialized) {
      await _favoriteBoxInstance!.close();
      _isInitialized = false;
    }
  }
}