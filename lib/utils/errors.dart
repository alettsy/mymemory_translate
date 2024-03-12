/// The error used when a required String parameter is given as an empty String
/// when it should not be empty.
class EmptyStringError extends Error {
  final String message;

  EmptyStringError(this.message);

  @override
  String toString() {
    return 'EmptyStringError(message: $message)';
  }
}

/// The general exception used for any runtime issues encountered by the API.
class MyMemoryException implements Exception {
  final String message;

  MyMemoryException(this.message);

  @override
  String toString() {
    return 'MyMemoryException(message: $message)';
  }
}
