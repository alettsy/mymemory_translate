class EmptyStringError extends Error {
  final String message;

  EmptyStringError(this.message);

  @override
  String toString() {
    return 'EmptyStringError(message: $message)';
  }
}

class TranslationApiException implements Exception {
  final String message;

  TranslationApiException(this.message);

  @override
  String toString() {
    return 'TranslationApiException(message: $message)';
  }
}
