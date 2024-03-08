import 'package:mymemory_translate/models/response_data.dart';
import 'package:mymemory_translate/models/translation_match.dart';

class TranslationResponse {
  final ResponseData responseData;
  final bool? quotaFinished;
  final bool? mtLangSupport;
  final String responseDetails;
  final int responseStatus;
  final int? responderId;
  final int? exceptionCode;
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
      ResponseData.fromJson(json['responseData']),
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
