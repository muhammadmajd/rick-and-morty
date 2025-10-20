import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/character.dart';
import '../controller/favorite_controller.dart';

class FavoriteIcon extends StatelessWidget {
  final Character character;
  final Color? color;
  final double size;

  const FavoriteIcon({
    super.key,
    required this.character,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.find<FavoriteController>();

    return Obx(() {
      // Check if character exists in the favorites list (local state)
      final isFav = favoriteController.favoriteCharacters.any((fav) => fav.id == character.id);

      return IconButton(
        icon: Icon(
          isFav ? Icons.star : Icons.star_border_outlined,
          color: isFav ? Colors.yellowAccent : color ?? Colors.grey,
          size: size,
        ),
        onPressed: () {
          favoriteController.toggleFavorite(character);
        },
        tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
      );
    });
  }
}