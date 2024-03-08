library mymemory_translate;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mymemory_translate/models/translation._response.dart';
import 'package:mymemory_translate/utils/errors.dart';

/// The base path of the MyMemory translation API.
const String _baseUrl = "https://api.mymemory.translated.net";

/// A simple API to communicate with the [MyMemory](https://mymemory.translated.net)
/// translation API.
///
/// The API spec can be found [here](https://mymemory.translated.net/doc/spec.php).
class MyMemoryTranslate {
  /// The HTTP client used to make the GET requests to the API.
  final http.Client _httpClient;

  /// A unique [key] generated from your username and password  by using the
  /// [keygen] function. You can use it to access your private glossary, by
  /// utilizing the [translate], [setTranslation], and [importTranslations]
  /// functions.
  String? key;

  /// The [email] to use to get 50,000 characters per day instead of the
  /// default 5,000. Any valid email will work.
  String? email;

  MyMemoryTranslate(this._httpClient, {this.key, this.email});

  /// [translate] the [text] string [from] one language [to] another.
  ///
  /// Set [onlyPrivate] to `true` to access your private glossary. A [key] is
  /// required to access your private glossary, which can be generated using the
  /// [keygen] function.
  ///
  /// An [ip] address can be provided for high volume usage.
  ///
  /// If [text], [from], or [to] are empty strings, then an [EmptyStringError]
  /// will be thrown.
  ///
  /// If the status code from the API is not 200, a [TranslationApiException]
  /// is thrown.
  Future<TranslationResponse> translate(String text, String from, String to,
      {bool useMachineTranslation = true,
      bool onlyPrivate = false,
      String? ip}) async {
    if (text.isEmpty || from.isEmpty || to.isEmpty) {
      throw EmptyStringError(
          "'text', 'from', and 'to' cannot be empty strings");
    }

    var url =
        '$_baseUrl/get?q=$text&langpair=$from|$to&mt=${useMachineTranslation as int}&onlyprivate=${onlyPrivate as int}';

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

  /// Generate the [key] using a [username] and [password].
  ///
  /// If [username] or [password] are empty strings, then an [EmptyStringError]
  /// is thrown.
  ///
  /// If the status code from the API is not 200, a [TranslationApiException]
  /// is thrown.
  Future<String> keygen(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw EmptyStringError(
          "'username' and 'password' cannot be empty strings");
    }

    var url = '$_baseUrl/keygen?user=$username&pass=$password';

    var response = await _httpClient.get(Uri.parse(url));

    var json = jsonDecode(response.body);

    if (json['responseStatus'].toString() != "200") {
      throw TranslationApiException(json['responseDetails']);
    }

    var key = json['key'];

    this.key = key;

    return key;
  }

  /// Set the translated text [from] the [source], [to] the [target].
  ///
  /// If [useKey] is `true` then the translation will only be set in your
  /// private glossary.
  ///
  /// If [source], [target], [to], or [from] are empty strings, then an
  /// [EmptyStringError] is thrown.
  Future<bool> setTranslation(
      String source, String target, String from, String to,
      {bool useKey = false}) async {
    if (useKey && key == null) {
      throw TranslationApiException("cannot use key because it is null");
    }

    if (source.isEmpty || target.isEmpty || from.isEmpty || to.isEmpty) {
      throw EmptyStringError(
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
