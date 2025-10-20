// lib/core/utils/sort_options.dart
enum CharacterSortOption {
  nameAscending,
  nameDescending,
  status,
  species,
  gender,
}

extension CharacterSortOptionExtension on CharacterSortOption {
  String get displayName {
    switch (this) {
      case CharacterSortOption.nameAscending:
        return 'Name (A-Z)';
      case CharacterSortOption.nameDescending:
        return 'Name (Z-A)';
      case CharacterSortOption.status:
        return 'Status';
      case CharacterSortOption.species:
        return 'Species';
      case CharacterSortOption.gender:
        return 'Gender';
    }
  }
}