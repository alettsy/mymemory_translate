/// Data about a potential match for a translation.
class TranslationMatch {
  /// The [id] of the translation.
  final String id;

  /// The source text.
  final String segment;

  /// The translated text.
  final String translation;

  /// The [source] language.
  final String source;

  /// The [target] language.
  final String target;

  /// The [quality] value out of 100 of the translation.
  final String quality;

  /// The [reference] of the translation.
  final String? reference;

  /// How many times the translation has been used.
  final int usageCount;

  /// The [subject] of the translation.
  final String subject;

  /// The user which contributed the translation.
  final String createdBy;

  /// The user which updated the translation last.
  final String lastUpdatedBy;

  /// The date the translation was created.
  final String createDate;

  /// The date the translation was last updated.
  final String lastUpdateDate;

  /// The accuracy of the match between 0 and 1.
  final double match;

  TranslationMatch(
    this.id,
    this.segment,
    this.translation,
    this.source,
    this.target,
    this.quality,
    this.reference,
    this.usageCount,
    this.subject,
    this.createdBy,
    this.lastUpdatedBy,
    this.createDate,
    this.lastUpdateDate,
    this.match,
  );

  factory TranslationMatch.fromJson(Map<String, dynamic> json) {
    return TranslationMatch(
      json['id'],
      json['segment'],
      json['translation'],
      json['source'],
      json['target'],
      json['quality'].toString(),
      json['reference'],
      json['usage-count'],
      json['subject'],
      json['created-by'],
      json['last-updated-by'],
      json['create-date'],
      json['last-update-date'],
      double.parse(json['match'].toString()),
    );
  }
}
