
  import '../repositories/character_repository.dart';
  import '../entities/location.dart';

  class GetLocationDetail {
    final CharacterRepository repository;

    GetLocationDetail(this.repository);

    Future<Location> call(String id) async {
      return await repository.getLocationDetail(id);
    }
  }




