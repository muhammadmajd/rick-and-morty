
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../core/utils/check_internet/network_manager.dart';
import '../../core/utils/popups/loaders.dart';
import '../../core/utils/sort/sort_options.dart';
import '../../domain/usecases/get_characters.dart';
import '../../domain/entities/character.dart';
import '../../domain/entities/pagination_info.dart';
import 'favorite_controller.dart';


class CharacterController extends GetxController {
  final GetCharacters getCharacters;

  CharacterController({required this.getCharacters});

  final RxList<Character> characters = <Character>[].obs;
  final Rx<PaginationInfo?> paginationInfo = Rx<PaginationInfo?>(null);
  final RxInt currentPage = 1.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxnString errorMessage = RxnString();
  final Rx<CharacterSortOption> currentSortOption =
  Rx<CharacterSortOption>(CharacterSortOption.nameAscending);

  @override
  void onInit() {
    fetchCharacters();
    super.onInit();
  }

  Future<void> fetchCharacters({int page = 1, String? name}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = null;


      // Check Internet Connectivity
      final isConnected = await NetworkManager. instance.isConnected ();

      if (!isConnected) {
        TLoaders.errorSnackBar (title: 'Oh Snap!', message: "There is no internet!");

        return;
      }

      final (info, charactersList) = await getCharacters(
        page: page,
        nameFilter: name,
      );

      if (page == 1) {
        characters.assignAll(charactersList);
      } else {
        characters.addAll(charactersList);
      }

      // Apply sorting after loading data
      applySorting();

      paginationInfo.value = info;
      currentPage.value = page;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      if (kDebugMode) {
        print('Error loading page $page: $e');
      }
      TLoaders.errorSnackBar (title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Apply sorting to the characters list
  void applySorting() {
    try {
      final sortedCharacters = List<Character>.from(characters);

      switch (currentSortOption.value) {
        case CharacterSortOption.nameAscending:
          sortedCharacters.sort((a, b) => a.name.compareTo(b.name));
          break;
        case CharacterSortOption.nameDescending:
          sortedCharacters.sort((a, b) => b.name.compareTo(a.name));
          break;
        case CharacterSortOption.status:
          sortedCharacters.sort((a, b) => a.status.compareTo(b.status));
          break;
        case CharacterSortOption.species:
          sortedCharacters.sort((a, b) => a.species.compareTo(b.species));
          break;
        case CharacterSortOption.gender:
          sortedCharacters.sort((a, b) => a.gender.compareTo(b.gender));
          break;
      }

      characters.assignAll(sortedCharacters);
    }  catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      if (kDebugMode) {
        print('Error apply sorting : $e');
      }
      TLoaders.errorSnackBar (title: 'Oh Snap!', message: e.toString());
    }
  }

  // Change sort option
  void changeSortOption(CharacterSortOption newOption) {
    try {
      currentSortOption.value = newOption;
      applySorting();
    }  catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      if (kDebugMode) {
        print('Error change option sorting : $e');
      }
      TLoaders.errorSnackBar (title: 'Oh Snap!', message: e.toString());
    }
  }

  void searchCharacters(String query) {
    try {
      searchQuery.value = query;
      currentPage.value = 1;
      fetchCharacters(page: 1, name: query.isEmpty ? null : query);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      if (kDebugMode) {
        print('Error searching : $e');
      }
      TLoaders.errorSnackBar (title: 'Oh Snap!', message: e.toString());
    }
  }

  void loadNextPage() {
    try {
      final nextPage = currentPage.value + 1;
      final totalPages = paginationInfo.value?.pages ?? 1;


      if (nextPage <= totalPages && !isLoading.value) {

        fetchCharacters(page: nextPage,
            name: searchQuery.value.isEmpty ? null : searchQuery.value);
      } else {
        TLoaders.warningSnackBar (title: 'Oh !', message: "There is no more data");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      if (kDebugMode) {
        print('Error loading next page : $e');
      }
      TLoaders.errorSnackBar (title: 'Oh Snap!', message: e.toString());
    }
  }

  void refreshCharacters() {
    fetchCharacters(page: 1, name: searchQuery.value.isEmpty ? null : searchQuery.value);
  }

  /// toggle Favorite
  Future<void> toggleFavorite(String characterId, bool isFavorite) async {
    try {
      final character = characters.firstWhere((char) => char.id == characterId);
      final favoriteController = Get.find<FavoriteController>();

      if (isFavorite) {
        await favoriteController.addToFavorites(character);
      } else {
        await favoriteController.removeFromFavorites(characterId);
      }

      // Update the character in the list
      final index = characters.indexWhere((char) => char.id == characterId);
      if (index != -1) {
        final updatedCharacter = characters[index].copyWith(isFavorite: isFavorite);
        characters[index] = updatedCharacter;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling favorite: $e');
      }
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update favorite');
    }
  }
}
