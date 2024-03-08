import 'package:flutter/material.dart';

class EmptyStringError extends ErrorDescription {
  EmptyStringError(super.message);
}

class TranslationApiException implements Exception {
  final String error;

  TranslationApiException(this.error);

  @override
  String toString() {
    return 'TranslationApiException(error: $error)';
  }
}
