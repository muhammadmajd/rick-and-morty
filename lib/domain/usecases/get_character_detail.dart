
import '../repositories/character_repository.dart';
import '../entities/character_detail.dart';

class GetCharacterDetail {
  final CharacterRepository repository;

  GetCharacterDetail(this.repository);

  Future<CharacterDetail> call(String id) async {
    return await repository.getCharacterDetail(id);
  }
}