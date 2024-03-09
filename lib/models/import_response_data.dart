/// The response data returned from importing a translation file.
class ImportResponseData {
  final String uuid;
  final String? id;
  final String? creationDate;
  final int? totals;
  final int completed;
  final int skipped;
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
