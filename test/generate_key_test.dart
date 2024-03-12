import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mymemory_translate/mymemory_translate.dart';
import 'package:mymemory_translate/utils/errors.dart';
import 'package:test/test.dart';

import 'mymemory_translate_test.mocks.dart';

var successfulResponse = jsonEncode({"key": "1234567890"});

var invalidCredentialsResponse = jsonEncode({
  "responseData": {"translatedText": "INVALID CREDENTIALS"},
  "quotaFinished": null,
  "mtLangSupported": null,
  "responseDetails": "INVALID CREDENTIALS",
  "responseStatus": "403",
  "responderId": null,
  "exception_code": null,
  "matches": ""
});

void main() {
  MockClient httpClient = MockClient();
  late MyMemoryTranslate myMemoryTranslate;

  setUp(() {
    myMemoryTranslate = MyMemoryTranslate(httpClient);
  });

  test('successful key generation', () async {
    when(httpClient.get(any)).thenAnswer(
        (inv) => Future.value(http.Response(successfulResponse, 200)));

    var response = await myMemoryTranslate.generateKey('username', 'password');

    expect(response, '1234567890');
    expect(myMemoryTranslate.key, '1234567890');
  });

  test('empty string parameter throws error', () {
    when(httpClient.get(any))
        .thenAnswer((inv) => Future.value(http.Response('', 200)));

    expect(
      () async => await myMemoryTranslate.generateKey('', 'password'),
      throwsA(isA<EmptyStringError>()),
    );
  });

  test('invalid credentials throws an exception', () {
    when(httpClient.get(any)).thenAnswer(
        (inv) => Future.value(http.Response(invalidCredentialsResponse, 200)));

    expect(
      () async => await myMemoryTranslate.generateKey('username', 'apple'),
      throwsA(isA<MyMemoryException>()),
    );
  });

  test('connection error throws exception', () {
    when(httpClient.get(any))
        .thenThrow(http.ClientException("Connection failed"));

    expect(
      () async => await myMemoryTranslate.generateKey('username', 'password'),
      throwsA(isA<http.ClientException>()),
    );
  });

  test('non-200 response throws exception', () {
    when(httpClient.get(any))
        .thenAnswer((inv) => Future.value(http.Response('', 403)));

    expect(
      () async => await myMemoryTranslate.generateKey('username', 'apple'),
      throwsA(isA<MyMemoryException>()),
    );
  });
}
