library mymemory_translate;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymemory_translate/models/translation._response.dart';
import 'package:mymemory_translate/utils/errors.dart';

const String _baseUrl = "https://api.mymemory.translated.net";

class MyMemoryTranslate {
  final http.Client _httpClient;
  String? key;
  String? email;

  MyMemoryTranslate(this._httpClient, {this.key, this.email});

  Future<TranslationResponse> translate(String text, String from, String to,
      {int useMachineTranslation = 1, int onlyPrivate = 0, String? ip}) async {
    if (text.isEmpty || from.isEmpty || to.isEmpty) {
      throw EmptyStringError(
          "'text', 'from', and 'to' cannot be empty strings");
    }

    var url =
        '$_baseUrl/get?q=$text&langpair=$from|$to&mt=$useMachineTranslation&onlyprivate=$onlyPrivate';

    if (ip != null) '$url&ip=$ip';
    if (key != null) '$url&key=$key';
    if (email != null) '$url&de=$email';

    var response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw TranslationApiException(response.body);
    }

    var result = TranslationResponse.fromJson(jsonDecode(response.body));

    if (result.responseStatus != 200) {
      throw TranslationApiException(result.responseDetails);
    }

    return result;
  }

  Future<String> keygen(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw ErrorDescription(
          "'username' and 'password' cannot be empty strings");
    }

    var url = '$_baseUrl/keygen?user=$username&pass=$password';

    var response = await _httpClient.get(Uri.parse(url));

    var key = jsonDecode(response.body)['key'];

    this.key = key;

    return key;
  }

  Future<bool> setTranslation(
      String source, String target, String from, String to,
      {bool useKey = false}) async {
    if (useKey && key == null) {
      throw Exception("cannot use key because it is null");
    }

    if (source.isEmpty || target.isEmpty || from.isEmpty || to.isEmpty) {
      throw ErrorDescription(
          "'source', 'target', 'from', and 'to' cannot be empty strings");
    }

    var url = '$_baseUrl/set?seg=$source&tra=$target&langpair=$from|$to';

    if (useKey) '$url&key=$key';
    if (email != null) '$url&de=$email';

    var response = await _httpClient.get(Uri.parse(url));

    // TODO: check actual response and return accordingly

    return response.statusCode == 200;
  }

  // TODO: status
  // TODO: import
  // TODO: subjects
}
