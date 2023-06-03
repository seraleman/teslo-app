class ConnectionTimeout implements Exception {}

class InvalidToken implements Exception {}

class WrongCredential implements Exception {}

class CustomError implements Exception {
  final String message;

  CustomError({required this.message});
}
