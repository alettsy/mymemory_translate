import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mymemory_translate/mymemory_translate.dart';
import 'package:mymemory_translate/utils/errors.dart';

import 'mymemory_translate_test.mocks.dart';

var successfulResponse = jsonEncode({
  "responseData": "OK",
  "responseStatus": 200,
  "responseDetails": ["003c6005-b10c-25db-381a-9d06644bf1c8"]
});

var invalidResponse = jsonEncode({
  "responseData": {
    "translatedText":
        "'' IS AN INVALID TARGET LANGUAGE . EXAMPLE: LANGPAIR=EN|IT USING 2 LETTER ISO OR RFC3066 LIKE ZH-CN. ALMOST ALL LANGUAGES SUPPORTED BUT SOME MAY HAVE NO CONTENT"
  },
  "quotaFinished": null,
  "mtLangSupported": null,
  "responseDetails":
      "'' IS AN INVALID TARGET LANGUAGE . EXAMPLE: LANGPAIR=EN|IT USING 2 LETTER ISO OR RFC3066 LIKE ZH-CN. ALMOST ALL LANGUAGES SUPPORTED BUT SOME MAY HAVE NO CONTENT",
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

  test('true useKey with null key throws exception', () {
    expect(
      () async => await myMemoryTranslate
          .setTranslation('Hello', 'Hola', 'en-us', 'es', useKey: true),
      throwsA(isA<TranslationApiException>()),
    );
  });

  test('empty string parameter throws error', () {
    expect(
      () async =>
          await myMemoryTranslate.setTranslation('Hello', 'Hola', 'en-us', ''),
      throwsA(isA<EmptyStringError>()),
    );
  });

  test('non-200 response throws exception', () {
    when(httpClient.get(any))
        .thenAnswer((inv) => Future.value(http.Response('', 403)));

    expect(
      () async => await myMemoryTranslate.setTranslation(
          'Hello', 'Hola', 'en-us', 'es'),
      throwsA(isA<TranslationApiException>()),
    );
  });

  test('non-200 API response throws exception', () {
    when(httpClient.get(any))
        .thenAnswer((inv) => Future.value(http.Response(invalidResponse, 200)));

    expect(
      () async => await myMemoryTranslate.setTranslation(
          'Hello', 'Hola', 'en-us', 'es'),
      throwsA(isA<TranslationApiException>()),
    );
  });

  test('successful response returns translation UUID', () async {
    when(httpClient.get(any)).thenAnswer(
        (inv) => Future.value(http.Response(successfulResponse, 200)));

    var result =
        await myMemoryTranslate.setTranslation('Hello', 'Hola', 'en-us', 'es');

    expect(result, '003c6005-b10c-25db-381a-9d06644bf1c8');
  });
}
