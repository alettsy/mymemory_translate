class ResponseData {
  final String translatedText;
  final double? match;

  ResponseData(this.translatedText, this.match);

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      json['translatedText'],
      json['match'],
    );
  }
}
