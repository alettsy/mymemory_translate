import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mymemory_translate/models/import_response_data.dart';
import 'package:mymemory_translate/mymemory_translate.dart';
import 'package:mymemory_translate/utils/errors.dart';
import 'package:test/test.dart';

import 'mymemory_translate_test.mocks.dart';

var successfulResponse = jsonEncode({
  "messageType": "import",
  "responseData": {
    "uuid": "1234567890",
    "id": "29874983753298",
    "creation_date": "2024-03-10 18:41:14",
    "totals": 10,
    "completed": 1,
    "skipped": 0,
    "status": 1
  },
  "responseStatus": 200
});

var invalidResponse = jsonEncode({
  "messageType": "import",
  "responseData": {
    "uuid": "123",
    "id": null,
    "creation_date": "2024-03-10 18:42:02",
    "totals": null,
    "completed": 0,
    "skipped": 0,
    "status": 2
  },
  "responseStatus": 404
});

var invalidMessageType = jsonEncode({
  "messageType": "other",
  "responseData": {
    "uuid": "123",
    "id": '1234345646',
    "creation_date": "2024-03-10 18:42:02",
    "totals": 3,
    "completed": 0,
    "skipped": 0,
    "status": 2
  },
  "responseStatus": 200
});

void main() {
  MockClient httpClient = MockClient();
  late MyMemoryTranslate myMemoryTranslate;

  setUp(() {
    myMemoryTranslate = MyMemoryTranslate(httpClient);
  });

  test('empty string parameter throws error', () async {
    when(httpClient.get(any))
        .thenAnswer((inv) => Future.value(http.Response('', 200)));

    expect(
      () async => await myMemoryTranslate.getImportStatus(''),
      throwsA(isA<EmptyStringError>()),
    );
  });

  test('invalid uuid throws exception', () {
    when(httpClient.get(any))
        .thenAnswer((inv) => Future.value(http.Response(invalidResponse, 200)));

    expect(
      () async => await myMemoryTranslate.getImportStatus('123'),
      throwsA(isA<MyMemoryException>()),
    );
  });

  test('successful uuid returns status object', () async {
    when(httpClient.get(any)).thenAnswer(
        (inv) => Future.value(http.Response(successfulResponse, 200)));

    var response = await myMemoryTranslate.getImportStatus('1234567890');

    expect(response, isA<ImportResponseData>());
    expect(response.uuid, "1234567890");
    expect(response.id, "29874983753298");
    expect(response.creationDate, "2024-03-10 18:41:14");
    expect(response.totals, 10);
    expect(response.completed, 1);
    expect(response.skipped, 0);
    expect(response.status, 1);
  });

  test('non-200 response throws exception', () {
    when(httpClient.get(any))
        .thenAnswer((inv) => Future.value(http.Response('', 403)));

    expect(
      () async => await myMemoryTranslate.getImportStatus('1234567890'),
      throwsA(isA<MyMemoryException>()),
    );
  });

  test('connection error throws exception', () {
    when(httpClient.get(any))
        .thenThrow(http.ClientException("Connection failed"));

    expect(
      () async => await myMemoryTranslate.getImportStatus('1234567890'),
      throwsA(isA<http.ClientException>()),
    );
  });

  test('invalid messageType throws exception', () {
    when(httpClient.get(any)).thenAnswer(
        (inv) => Future.value(http.Response(invalidMessageType, 200)));

    expect(
      () async => await myMemoryTranslate.getImportStatus('1234567890'),
      throwsA(isA<MyMemoryException>()),
    );
  });
}
