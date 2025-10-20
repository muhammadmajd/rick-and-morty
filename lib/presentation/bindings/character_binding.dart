import 'package:get/get.dart';
import '../../core/utils/check_internet/network_manager.dart';
import '../../data/datasources/character_remote_data_source.dart';
import '../../data/datasources/favorite_local_data_source.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/usecases/get_characters.dart';
import '../../domain/usecases/get_character_detail.dart';
import '../../domain/usecases/get_location_detail.dart';
import '../controller/character_controller.dart';
import '../controller/favorite_controller.dart';


class CharacterBinding extends Bindings {
  @override
  void dependencies() {
    /// Network manager
    Get.put(NetworkManager(), permanent: true);

    /// Data sources
    Get.lazyPut<CharacterRemoteDataSource>(
          () => CharacterRemoteDataSource(),
    );

    /// Favorite Local Data Source
    Get.lazyPut<FavoriteLocalDataSource>(
          () => FavoriteLocalDataSource(),
    );

    /// Register  the abstract

    Get.lazyPut<CharacterRepository>(
          () => CharacterRepositoryImpl(
        remoteDataSource: Get.find<CharacterRemoteDataSource>(),
        favoriteLocalDataSource: Get.find<FavoriteLocalDataSource>(),
      ),
    );


    /// Use cases
    Get.lazyPut<GetCharacters>(
          () => GetCharacters(Get.find<CharacterRepository>()),
    );

    Get.lazyPut<GetCharacterDetail>(
          () => GetCharacterDetail(Get.find<CharacterRepository>()),
    );

    Get.lazyPut<GetLocationDetail>(
          () => GetLocationDetail(Get.find<CharacterRepository>()),
    );

    /// Controllers
    //CharacterController
    Get.lazyPut<CharacterController>(
          () => CharacterController(
        getCharacters: Get.find<GetCharacters>(),
      ),
    );

    // Favorite Controller
    Get.lazyPut<FavoriteController>(
          () => FavoriteController(
        characterRepository: Get.find<CharacterRepository>(), // Now it works!
      ),
    );

    /// Character Repository
    Get.lazyPut<CharacterRepository>(
          () => CharacterRepositoryImpl(
        remoteDataSource: Get.find<CharacterRemoteDataSource>(),
        favoriteLocalDataSource: Get.find<FavoriteLocalDataSource>(),
      ),
    );




  }
}