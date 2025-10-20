

import 'package:graphql_flutter/graphql_flutter.dart';

import '../constents/api_constants.dart';

class GraphQLClientService{
  static GraphQLClient getClient() {
    final HttpLink httpLink = HttpLink(AppConstants.graphqlEndpoint);

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }
}