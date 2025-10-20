
class CharacterQueries {
/// query to get all Characters by paging
  static const String getCharacters = '''
    query GetCharacters(\$page: Int, \$filter: FilterCharacter) {
      characters(page: \$page, filter: \$filter) {
        info {
          count
          pages
          next
          prev
        }
        results {
          id     
          name
          status
          species
          type
          gender
          origin {
            name
          }
          location {
            name
          }
          image
          episode {
            id
          }
        }
      }
    }
  ''';


  ///  query for single character details
  static const String getCharacterById = '''
    query GetCharacterById(\$id: ID!) {
      character(id: \$id) {
        id
        name
        status
        species
        type
        gender
        origin {
          id
          name
          type
          dimension
          residents {
            id
            name
          }
        }
        location {
          id
          name
          type
          dimension
          residents {
            id
            name
          }
        }
        image
        episode {
          id
          name
          air_date
          episode
          characters {
            id
            name
          }
        }
        created
      }
    }
  ''';

  /// Query for location details by id
  static const String getLocationById = '''
    query GetLocationById(\$id: ID!) {
      location(id: \$id) {
        id
        name
        type
        dimension
        residents {
          id
          name
          image
          status
          species
        }
        created
      }
    }
  ''';

  /// Query for multiple episodes
  static const String getEpisodesByIds = '''
    query GetEpisodesByIds(\$ids: [ID!]!) {
      episodesByIds(ids: \$ids) {
        id
        name
        air_date
        episode
        characters {
          id
          name
          image
        }
        created
      }
    }
  ''';
  }
