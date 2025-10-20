
import '../repositories/character_repository.dart';
import '../entities/character.dart';
import '../entities/pagination_info.dart';

class GetCharacters {
  final CharacterRepository repository;

  GetCharacters(this.repository);

  Future<(PaginationInfo?, List<Character>)> call({
    int page = 1,
    String? nameFilter,
  }) async {
    return await repository.getCharacters(
      page: page,
      nameFilter: nameFilter,
    );
  }
}