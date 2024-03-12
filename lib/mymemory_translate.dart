library mymemory_translate;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/import_response_data.dart';
import 'models/translation._response.dart';
import 'utils/errors.dart';

const String _baseUrl = "https://api.mymemory.translated.net";

/// A simple API to communicate with the [MyMemory](https://mymemory.translated.net)
/// translation API.
///
/// The API spec can be found [here](https://mymemory.translated.net/doc/spec.php).
class MyMemoryTranslate {
  final http.Client _httpClient;

  /// A unique [key] generated from your username and password  by using the
  /// [generateKey] function. You can use it to access your private glossary, by
  /// utilizing the [translate], [setTranslation], and [importTranslations]
  /// functions.
  String? key;

  /// The [email] to use to get 50,000 characters per day instead of the
  /// default 5,000. Any valid email will work.
  String? email;

  MyMemoryTranslate(this._httpClient, {this.key, this.email});

  /// Gets the translated [text] input [from] one language [to] another.
  ///
  /// Returns the response object as a [TranslationResponse]. The machine
  /// translated text can be accessed with `response.responseData.translatedText`.
  /// Human matches can be accessed with `response.matches`.
  ///
  /// Set [private] to `true` to access your private glossary. A [key] is
  /// required to access your private glossary, which can be generated using the
  /// [generateKey] function.
  ///
  /// An [ip] address can be provided for high volume usage.
  ///
  /// Throws an [EmptyStringError] if [text], [from], or [to] are empty strings.
  ///
  /// Throws a [MyMemoryException] if the API returns an error or the
  /// response status code is not 200.
  Future<TranslationResponse> translate(String text, String from, String to,
      {bool useMachineTranslation = true,
      bool private = false,
      String? ip}) async {
    if (text.isEmpty || from.isEmpty || to.isEmpty) {
      throw EmptyStringError(
          "'text', 'from', and 'to' cannot be empty strings");
    }

    var url =
        '$_baseUrl/get?q=$text&langpair=$from|$to&mt=${_boolToInt(useMachineTranslation)}&onlyprivate=${_boolToInt(private)}';

    if (ip != null) '$url&ip=$ip';
    if (key != null) '$url&key=$key';
    if (email != null) '$url&de=$email';

    var response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw MyMemoryException(response.body);
    }

    var result = TranslationResponse.fromJson(jsonDecode(response.body));

    if (result.responseStatus != 200) {
      throw MyMemoryException(result.responseDetails);
    }

    return result;
  }

  /// Generates a [key] using a [username] and [password].
  ///
  /// Returns the generated [key].
  ///
  /// Throws an [EmptyStringError] if [username] or [password] are empty
  /// strings.
  ///
  /// Throws a [MyMemoryException] if the API returns an error or the
  /// response status code is not 200.
  Future<String> generateKey(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw EmptyStringError(
          "'username' and 'password' cannot be empty strings");
    }

    var url = '$_baseUrl/keygen?user=$username&pass=$password';

    var response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw MyMemoryException(response.body);
    }

    Map<String, dynamic> json = jsonDecode(response.body);

    if (json.containsKey('responseDetails')) {
      throw MyMemoryException(json['responseDetails']);
    }

    var key = json['key'];

    this.key = key;

    return key;
  }

  /// Set the translated text [from] the [source], [to] the [target].
  ///
  /// Returns the UUID of the newly set translation.
  ///
  /// If [private] is `true` then the translation will only be set in your
  /// private glossary. Otherwise, it's visible to everyone.
  ///
  /// Throws a [MyMemoryException] if the API returns an error or the
  /// response status code is not 200.
  Future<String> setTranslation(
      String source, String target, String from, String to,
      {bool private = false}) async {
    if (private && key == null) {
      throw MyMemoryException("cannot use key because it is null");
    }

    if (source.isEmpty || target.isEmpty || from.isEmpty || to.isEmpty) {
      throw EmptyStringError(
          "'source', 'target', 'from', and 'to' cannot be empty strings");
    }

    var url = '$_baseUrl/set?seg=$source&tra=$target&langpair=$from|$to';

    if (private) '$url&key=$key';
    if (email != null) '$url&de=$email';

    var response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw MyMemoryException(response.body);
    }

    var json = jsonDecode(response.body);

    if (int.parse(json['responseStatus'].toString()) != 200) {
      throw MyMemoryException(json['responseDetails']);
    }

    return json['responseDetails'][0];
  }

  /// Gets the current import status of a TM import with the given [uuid].
  ///
  /// Returns the response object as an [ImportResponseData].
  ///
  /// Throws an [EmptyStringError] if `uuid` is an empty string.
  ///
  /// Throws a [MyMemoryException] if the API returns an error or the
  /// response status code is not 200.
  Future<ImportResponseData> getImportStatus(String uuid) async {
    if (uuid.isEmpty) {
      throw EmptyStringError("'uuid' cannot be an empty string");
    }

    var url = '$_baseUrl/v2/import/status?uuid=$uuid';

    var response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw MyMemoryException(response.body);
    }

    var json = jsonDecode(response.body);

    if (int.parse(json['responseStatus'].toString()) != 200) {
      throw MyMemoryException('UUID not found');
    }

    if (json['messageType'] != 'import') {
      throw MyMemoryException('UUID does not point to import');
    }

    return ImportResponseData.fromJson(json['responseData']);
  }

  /// Imports a translation memory [file].
  ///
  /// ! ATTENTION: I don't think this endpoint actually works. I have tried to
  /// test it with a JavaScript application and it always returns an error or
  /// that the file is missing. Do not use.
  ///
  /// Returns `true` if the import was successful.
  ///
  /// You can provide a [name] and [subject] to describe your file. If a [name]
  /// isn't provided, the API will default to the name of the file. A [subject]
  /// is one of a predefined set of options on the API.
  ///
  /// You can provide a [sourceUrl] and [targetUrl] to give context for
  /// the source language and the target language.
  ///
  /// The [private] parameter can be used to make the translation private or
  /// public. It defaults to being public.
  ///
  /// Throws a [MyMemoryException] if [private] is `true` and [key] is
  /// `null`.
  // Future<bool> importTranslationMemoryFile(File file,
  //     {String? name,
  //     String? subject,
  //     bool private = false,
  //     Uri? sourceUrl,
  //     Uri? targetUrl}) async {
  //   if (private && key == null) {
  //     throw TranslationApiException("cannot use key because it is null");
  //   }
  //
  //   var request =
  //       http.MultipartRequest('POST', Uri.parse('$_baseUrl/v2/tmx/import'));
  //
  //   request.files
  //       .add(http.MultipartFile.fromBytes('tmx', file.readAsBytesSync()));
  //
  //   if (name != null) request.fields['name'] = name;
  //   if (subject != null) request.fields['subj'] = subject;
  //   if (sourceUrl != null) request.fields['surl'] = sourceUrl.toString();
  //   if (targetUrl != null) request.fields['turl'] = targetUrl.toString();
  //   if (key != null) request.fields['key'] = key!;
  //   request.fields['private'] = _boolToInt(private).toString();
  //
  //   request.headers['Content-Type'] = 'multipart/form-data';
  //
  //   var sent = await request.send();
  //   var response = await http.Response.fromStream(sent);
  //
  //   if (response.statusCode != 200) {
  //     throw TranslationApiException('invalid request - ${response.body}');
  //   }
  //
  //   var json = jsonDecode(response.body);
  //
  //   if (json['responseStatus'] != 200) {
  //     throw TranslationApiException(json['responseDetails']);
  //   }
  //
  //   // Should return a valid UUID, but response is empty or fails
  //   return response.statusCode == 200;
  // }

  int _boolToInt(bool value) {
    return value ? 1 : 0;
  }
}
