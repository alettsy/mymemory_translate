/// The response data returned from importing a translation file.
class ImportResponseData {
  /// The [uuid] of the import request.
  final String uuid;

  /// The [id] of the imported file.
  final String? id;

  /// The date the file was created.
  final String? creationDate;

  /// The total number of translations in the file.
  final int? totals;

  /// The number of translations imported.
  final int completed;

  /// The number of translations [skipped].
  final int skipped;

  /// The [status] of the import request.
  final int status;

  ImportResponseData(this.uuid, this.id, this.creationDate, this.totals,
      this.completed, this.skipped, this.status);

  factory ImportResponseData.fromJson(Map<String, dynamic> json) {
    return ImportResponseData(
      json['uuid'],
      json['id'],
      json['creation_date'],
      json['totals'],
      json['completed'],
      json['skipped'],
      json['status'],
    );
  }
}
