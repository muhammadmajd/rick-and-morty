
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../core/constents/image_strings.dart';
import '../../core/utils/popups/loaders.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';


class FavoriteController extends GetxController {
  final RxList<Character> favoriteCharacters = <Character>[].obs;
  final CharacterRepository characterRepository;

  FavoriteController({required this.characterRepository});

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // Load favorites from local storage
  Future<void> loadFavorites() async {
    try {
      final favorites = await characterRepository.getFavoriteCharacters();
      favoriteCharacters.assignAll(favorites);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading favorites: $e');
      }
    }
  }

  // Add character to favorites
  Future<void> addToFavorites(Character character) async {
    try {
      final isCurrentlyFavorite = await characterRepository.isFavorite(character.id);
      if (!isCurrentlyFavorite) {
        await characterRepository.addToFavorites(character);

        // Update local list
        final updatedCharacter = character.copyWith(isFavorite: true);
        favoriteCharacters.add(updatedCharacter);

        TLoaders.customToastAnimation(
            message: 'Added to favorites!',
            animation: TImages.doneJson
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to add to favorites'
      );
      if (kDebugMode) {
        print('Error adding to favorites: $e');
      }
    }
  }

  // Remove character from favorites
  Future<void> removeFromFavorites(String characterId) async {
    try {
      await characterRepository.removeFromFavorites(characterId);

      // Update local list
      favoriteCharacters.removeWhere((character) => character.id == characterId);

      TLoaders.customToastAnimation(
          message: 'Removed from favorites',
          animation: TImages.deleteJson
      );
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to remove from favorites'
      );
      if (kDebugMode) {
        print('Error removing from favorites: $e');
      }
    }
  }

  // Check if character is in favorites
  Future<bool> isFavorite(String characterId) async {
    return await characterRepository.isFavorite(characterId);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Character character) async {
    final isCurrentlyFavorite = await isFavorite(character.id);
    if (isCurrentlyFavorite) {
      await removeFromFavorites(character.id);
    } else {
      await addToFavorites(character);
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      for (final character in favoriteCharacters) {
        await characterRepository.removeFromFavorites(character.id);
      }
      favoriteCharacters.clear();

      TLoaders.customToastAnimation(
          message: 'All favorites cleared',
          animation: TImages.successJson
      );
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to clear favorites'
      );
      if (kDebugMode) {
        print('Error clearing favorites: $e');
      }
    }
  }

  // Get favorites count
  int get favoritesCount => favoriteCharacters.length;

  // Check if favorites is empty
  bool get hasFavorites => favoriteCharacters.isNotEmpty;
}