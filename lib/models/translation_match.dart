/// Data about a potential match for a translation.
class TranslationMatch {
  final String id;
  final String segment;
  final String translation;
  final String source;
  final String target;
  final String quality;
  final String? reference;
  final int usageCount;
  final String subject;
  final String createdBy;
  final String lastUpdatedBy;
  final String createDate;
  final String lastUpdateDate;
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
