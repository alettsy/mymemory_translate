library mymemory_translate;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mymemory_translate/models/translation._response.dart';

class MyMemoryTranslate {
  http.Client httpClient;
  String? key;
  String? email;

  MyMemoryTranslate(this.httpClient, {this.key, this.email});

  // TODO: add optional parameters
  // TODO: replace String langs with enumerations
  // todo: throw error if request fails or fail to parse?
  Future<TranslationResponse> translate(String text, String from, String to,
      {int mt = 1, int onlyPrivate = 0, String? ip}) async {
    var url =
        'https://api.mymemory.translated.net/get?q=$text&langpair=$from|$to&mt=$mt&onlyprivate=$onlyPrivate';

    if (ip != null) '$url&ip=$ip';
    if (key != null) '$url&key=$key';
    if (email != null) '$url&de=$email';

    var response = await httpClient.get(Uri.parse(url));

    return TranslationResponse.fromJson(jsonDecode(response.body));
  }
}
