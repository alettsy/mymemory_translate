/// The translated text and its match percentage.
class TranslationResponseData {
  final String translatedText;
  final double? match;

  TranslationResponseData(this.translatedText, this.match);

  factory TranslationResponseData.fromJson(Map<String, dynamic> json) {
    return TranslationResponseData(
      json['translatedText'],
      double.tryParse(json['match'].toString()),
    );
  }
}
