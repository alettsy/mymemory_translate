/// The translated text and its match percentage.
class TranslationResponseData {
  /// The translated text.
  final String? translatedText;

  /// The accuracy of the match between 0 and 1.
  final double? match;

  TranslationResponseData(this.translatedText, this.match);

  factory TranslationResponseData.fromJson(Map<String, dynamic> json) {
    return TranslationResponseData(
      json['translatedText'],
      double.tryParse(json['match'].toString()),
    );
  }
}
