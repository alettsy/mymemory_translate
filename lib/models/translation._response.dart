import 'translation_match.dart';
import 'translation_response_data.dart';

/// The response data returned from translating text.
class TranslationResponse {
  /// The response data returned from translating text. The match accuracy
  /// and the machine translated text are found here.
  final TranslationResponseData responseData;

  /// Whether the maximum character count usage per day has been met.
  final bool? quotaFinished;

  /// Whether the use of machine translation is enabled.
  final bool? mtLangSupport;

  /// Additional details about the response.
  final String responseDetails;

  /// The status code of the response.
  final int responseStatus;

  /// The ID of the responder.
  final int? responderId;

  /// The exception code of the response.
  final int? exceptionCode;

  /// The human contributed [matches] returned from translating text.
  final List<TranslationMatch> matches;

  TranslationResponse(
    this.responseData,
    this.quotaFinished,
    this.mtLangSupport,
    this.responseDetails,
    this.responseStatus,
    this.responderId,
    this.exceptionCode,
    this.matches,
  );

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    return TranslationResponse(
      TranslationResponseData.fromJson(json['responseData']),
      json['quotaFinished'],
      json['mtLangSupport'],
      json['responseDetails'],
      int.parse(json['responseStatus'].toString()),
      json['responderId'],
      json['exception_code'],
      ((json['matches'] == "" ? [] : json['matches']) as List)
          .map((e) => TranslationMatch.fromJson(e))
          .toList(),
    );
  }
}
