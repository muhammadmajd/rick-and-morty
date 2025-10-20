
import 'package:get/get.dart';
import '../../domain/usecases/get_character_detail.dart';
import '../../domain/entities/character_detail.dart';

class CharacterDetailController extends GetxController {
  final GetCharacterDetail getCharacterDetail;
  final String characterId;

  CharacterDetailController({
    required this.getCharacterDetail,
    required this.characterId,
  });

  final Rx<CharacterDetail?> characterDetail = Rx<CharacterDetail?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadCharacterDetail();
  }

  Future<void> loadCharacterDetail() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = null;

      final character = await getCharacterDetail(characterId);
      characterDetail.value = character;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

    } finally {
      isLoading.value = false;
    }
  }

  void refreshCharacterDetail() {
    loadCharacterDetail();
  }
}