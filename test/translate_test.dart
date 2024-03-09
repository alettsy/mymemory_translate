import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mymemory_translate/mymemory_translate.dart';
import 'package:mymemory_translate/utils/errors.dart';
import 'package:test/test.dart';

import 'mymemory_translate_test.mocks.dart';

var successResponse = jsonEncode({
  "responseData": {"translatedText": "Hola", "match": 1.0},
  "quotaFinished": false,
  "mtLangSupported": null,
  "responseDetails": "",
  "responseStatus": 200,
  "responderId": null,
  "exception_code": null,
  "matches": [
    {
      "id": "6544322345",
      "segment": "Hello",
      "translation": "Hola",
      "source": "en-us",
      "target": "es",
      "quality": "100",
      "reference": null,
      "usage-count": 2,
      "subject": "All",
      "created-by": "Person1",
      "last-updated-by": "Person1",
      "create-date": "2022-07-07 11:52:18",
      "last-update-date": "2022-07-07 11:52:18",
      "match": 1.0
    }
  ]
});

var languageMissingResponse = jsonEncode({
  "responseData": {
    "translatedText":
        "'IL' IS AN INVALID TARGET LANGUAGE . EXAMPLE: LANGPAIR=EN|IT USING 2 LETTER ISO OR RFC3066 LIKE ZH-CN. ALMOST ALL LANGUAGES SUPPORTED BUT SOME MAY HAVE NO CONTENT"
  },
  "quotaFinished": null,
  "mtLangSupported": null,
  "responseDetails":
      "'IL' IS AN INVALID TARGET LANGUAGE . EXAMPLE: LANGPAIR=EN|IT USING 2 LETTER ISO OR RFC3066 LIKE ZH-CN. ALMOST ALL LANGUAGES SUPPORTED BUT SOME MAY HAVE NO CONTENT",
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

  test('new memory translate object', () {
    expect(myMemoryTranslate.key, null);
    expect(myMemoryTranslate.email, null);
  });

  test('successful translation response', () async {
    when(httpClient.get(any))
        .thenAnswer((inv) => Future.value(http.Response(successResponse, 200)));

    // ip parameter added for test coverage only
    var result = await myMemoryTranslate.translate('Hello', 'en-us', 'es',
        ip: '0.0.0.0');

    expect(result.responseData.translatedText, 'Hola');
    expect(result.responseData.match, 1.0);
    expect(result.quotaFinished, false);
    expect(result.mtLangSupport, null);
    expect(result.responseDetails, '');
    expect(result.responseStatus, 200);
    expect(result.responderId, null);
    expect(result.exceptionCode, null);
    expect(result.matches.length, 1);
    expect(result.matches[0].id, '6544322345');
    expect(result.matches[0].segment, 'Hello');
    expect(result.matches[0].translation, 'Hola');
    expect(result.matches[0].source, 'en-us');
    expect(result.matches[0].target, 'es');
    expect(result.matches[0].quality, '100');
    expect(result.matches[0].reference, null);
    expect(result.matches[0].usageCount, 2);
    expect(result.matches[0].subject, 'All');
    expect(result.matches[0].createdBy, 'Person1');
    expect(result.matches[0].lastUpdatedBy, 'Person1');
    expect(result.matches[0].createDate, '2022-07-07 11:52:18');
    expect(result.matches[0].lastUpdateDate, '2022-07-07 11:52:18');
    expect(result.matches[0].match, 1.0);
  });

  test('invalid language response throws exception', () async {
    when(httpClient.get(any)).thenAnswer(
        (inv) => Future.value(http.Response(languageMissingResponse, 200)));

    expect(
      () async => await myMemoryTranslate.translate('Hello', 'en-us', 'il'),
      throwsA(isA<TranslationApiException>()),
    );
  });

  test('empty string throws error', () async {
    expect(
      () async => await myMemoryTranslate.translate('', 'en-us', 'il'),
      throwsA(isA<EmptyStringError>()),
    );
  });

  test('non-200 status throws exception', () async {
    expect(
      () async => await myMemoryTranslate.translate('Hello', 'en-us', 'il'),
      throwsA(isA<TranslationApiException>()),
    );
  });

  test('connection error throws exception', () {
    when(httpClient.get(any))
        .thenThrow(http.ClientException("Connection failed"));

    expect(
      () async => await myMemoryTranslate.translate('Hello', 'en-us', 'il'),
      throwsA(isA<http.ClientException>()),
    );
  });
}
