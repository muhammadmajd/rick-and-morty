
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rickmorty/core/constents/colors.dart';
import '../../core/utils/helper/helper_functions.dart';
import '../controller/favorite_controller.dart';
import '../widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.find<FavoriteController>();
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Characters',style: TextStyle(color: TColors.white),),
        backgroundColor:dark? TColors.darkerGrey: TColors.primary ,
        actions: [
          Obx(() {
            if (favoriteController.favoriteCharacters.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.delete_outline,
                color: TColors.white,
                ),
                onPressed: () {
                  _showClearAllDialog(favoriteController);
                },
              );
            }
            return const SizedBox();
          }),
        ],
      ),
      body: Obx(() {
        final favorites = favoriteController.favoriteCharacters;

        if (favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No favorite characters yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap the heart icon to add characters to favorites',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${favorites.length} favorite character${favorites.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final character = favorites[index];
                  return Dismissible(
                    key: Key(character.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await _showDeleteDialog(character.name, favoriteController, character.id);
                    },
                    child: CharacterCard(character: character),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  /// delete Dialog
  Future<bool> _showDeleteDialog(String characterName, FavoriteController controller, String characterId) async {
    bool? result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Remove from Favorites'),
        content: Text('Are you sure you want to remove $characterName from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
  /// clear all Dialog
  void _showClearAllDialog(FavoriteController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all characters from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearAllFavorites();
              Get.back();
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}