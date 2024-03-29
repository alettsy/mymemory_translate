# mymemory_translate

A simple API to get and manage translations from the
[MyMemory](https://mymemory.translated.net/) translation REST API.

A full specification for the API can be found 
[here](https://mymemory.translated.net/doc/spec.php).

## Getting started

In your Flutter project add the dependency:

```yaml
dependencies:
    mymemory_translate: ^2.0.0
```

or run `flutter pub add mymemory_translate`.

## Usage Examples

### Translating

```dart
void main() async {
  
  // Create a new translator without a key or email
  var translator = MyMemoryTranslator(http.Client);
  
  // Translate "Hello" from English to German
  var result = await translator.translate('Hello', 'en-us', 'de');
  
  // Prints "Hallo"
  print(result.responseData.translatedText);
  
  // You can set your email to get 50,000 characters per day
  // instead of only 5,000.
  translator.email = "email@email.com";
}
```

### Generating an API Key

```dart
void main() async {

  // Create a new translator without a key or email
  var translator = MyMemoryTranslator(http.Client);
  
  // Generate the API key with my username and password
  await translator.generateKey('myusername', 'mypassword');
  print(translator.key);
  
  // Now you can access your private glossary
  // For example, to get translations only from your private glossary
  var result = await translator.translate('Hello', 'en-us', 'de', private: true);

  // Or to set a translation in your private glossary
  await translator.setTranslation('Hello', 'Hallo', 'en-us', 'de', private: true);
}
```

### Setting Translations
```dart
void main() async {

  // Create a new translator without a key or email
  var translator = MyMemoryTranslator(http.Client);
  
  // Set "Hello" to "Hallo" from English to German
  await translator.setTranslation('Hello', 'Hallo', 'en-us', 'de');
}
```

## Languages

Currently accepted languages are as follows:
```json
{
  "Autodetect": "Autodetect",
  "Afrikaans": "af-ZA",
  "Albanian": "sq-AL",
  "Amharic": "am-ET",
  "Arabic": "ar-SA",
  "Armenian": "hy-AM",
  "Azerbaijani": "az-AZ",
  "Bajan": "bjs-BB",
  "Balkan Gipsy": "rm-RO",
  "Basque": "eu-ES",
  "Bemba": "bem-ZM",
  "Bengali": "bn-IN",
  "Bielarus": "be-BY",
  "Bislama": "bi-VU",
  "Bosnian": "bs-BA",
  "Breton": "br-FR",
  "Bulgarian": "bg-BG",
  "Burmese": "my-MM",
  "Catalan": "ca-ES",
  "Cebuano": "ceb-PH",
  "Chamorro": "ch-GU",
  "Chinese (Simplified)": "zh-CN",
  "Chinese Traditional": "zh-TW",
  "Comorian (Ngazidja)": "zdj-KM",
  "Coptic": "cop-EG",
  "Creole English (Antigua and Barbuda)": "aig-AG",
  "Creole English (Bahamas)": "bah-BS",
  "Creole English (Grenadian)": "gcl-GD",
  "Creole English (Guyanese)": "gyn-GY",
  "Creole English (Jamaican)": "jam-JM",
  "Creole English (Vincentian)": "svc-VC",
  "Creole English (Virgin Islands)": "vic-US",
  "Creole French (Haitian)": "ht-HT",
  "Creole French (Saint Lucian)": "acf-LC",
  "Creole French (Seselwa)": "crs-SC",
  "Creole Portuguese (Upper Guinea)": "pov-GW",
  "Croatian": "hr-HR",
  "Czech": "cs-CZ",
  "Danish": "da-DK",
  "Dutch": "nl-NL",
  "Dzongkha": "dz-BT",
  "English (UK)": "en-GB",
  "English (US)": "en-US",
  "Esperanto": "eo-EU",
  "Estonian": "et-EE",
  "Fanagalo": "fn-FNG",
  "Faroese": "fo-FO",
  "Finnish": "fi-FI",
  "French": "fr-FR",
  "Galician": "gl-ES",
  "Georgian": "ka-GE",
  "German": "de-DE",
  "Greek": "el-GR",
  "Greek (Classical)": "grc-GR",
  "Gujarati": "gu-IN",
  "Hausa": "ha-NE",
  "Hawaiian": "haw-US",
  "Hebrew": "he-IL",
  "Hindi": "hi-IN",
  "Hungarian": "hu-HU",
  "Icelandic": "is-IS",
  "Indonesian": "id-ID",
  "Inuktitut (Greenlandic)": "kl-GL",
  "Irish Gaelic": "ga-IE",
  "Italian": "it-IT",
  "Japanese": "ja-JP",
  "Javanese": "jv-ID",
  "Kabuverdianu": "kea-CV",
  "Kabylian": "kab-DZ",
  "Kannada": "kn-IN",
  "Kazakh": "kk-KZ",
  "Khmer": "km-KM",
  "Kinyarwanda": "rw-RW",
  "Kirundi": "rn-BI",
  "Korean": "ko-KR",
  "Kurdish": "ku-TR",
  "Kurdish Sorani": "ckb-IQ",
  "Kyrgyz": "ky-KG",
  "Lao": "lo-LA",
  "Latin": "la-VA",
  "Latvian": "lv-LV",
  "Lithuanian": "lt-LT",
  "Luxembourgish": "lb-LU",
  "Macedonian": "mk-MK",
  "Malagasy": "mg-MG",
  "Malay": "ms-MY",
  "Maldivian": "dv-MV",
  "Maltese": "mt-MT",
  "Manx Gaelic": "gv-IM",
  "Maori": "mi-NZ",
  "Marshallese": "mh-MH",
  "Mende": "men-SL",
  "Mongolian": "mn-MN",
  "Morisyen": "mfe-MU",
  "Nepali": "ne-NP",
  "Niuean": "niu-NU",
  "Norwegian": "no-NO",
  "Nyanja": "ny-MW",
  "Pakistani": "ur-PK",
  "Palauan": "pau-PW",
  "Panjabi": "pa-IN",
  "Papiamentu": "pap-CW",
  "Pashto": "ps-PK",
  "Persian": "fa-IR",
  "Pijin": "pis-SB",
  "Polish": "pl-PL",
  "Portuguese": "pt-PT",
  "Potawatomi": "pot-US",
  "Quechua": "qu-PE",
  "Romanian": "ro-RO",
  "Russian": "ru-RU",
  "Samoan": "sm-WS",
  "Sango": "sg-CF",
  "Scots Gaelic": "gd-GB",
  "Serbian": "sr-RS",
  "Shona": "sn-ZW",
  "Sinhala": "si-LK",
  "Slovak": "sk-SK",
  "Slovenian": "sl-SI",
  "Somali": "so-SO",
  "Sotho, Southern": "st-ST",
  "Spanish": "es-ES",
  "Sranan Tongo": "srn-SR",
  "Swahili": "sw-SZ",
  "Swedish": "sv-SE",
  "Swiss German": "de-CH",
  "Syriac (Aramaic)": "syc-TR",
  "Tagalog": "tl-PH",
  "Tajik": "tg-TJ",
  "Tamashek (Tuareg)": "tmh-DZ",
  "Tamil": "ta-LK",
  "Telugu": "te-IN",
  "Tetum": "tet-TL",
  "Thai": "th-TH",
  "Tibetan": "bo-CN",
  "Tigrinya": "ti-TI",
  "Tok Pisin": "tpi-PG",
  "Tokelauan": "tkl-TK",
  "Tongan": "to-TO",
  "Tswana": "tn-BW",
  "Turkish": "tr-TR",
  "Turkmen": "tk-TM",
  "Tuvaluan": "tvl-TV",
  "Ukrainian": "uk-UA",
  "Uma": "ppk-ID",
  "Uzbek": "uz-UZ",
  "Vietnamese": "vi-VN",
  "Wallisian": "wls-WF",
  "Welsh": "cy-GB",
  "Wolof": "wo-SN",
  "Xhosa": "xh-ZA",
  "Yiddish": "yi-YD",
  "Zulu": "zu-ZA"
}
```

## Current Issues

- The `subjects` endpoint seems to be missing from the API so there is
  no way to get the list of allowed subjects at the moment.
- The `v2/tmx/import` endpoint doesn't appear to work. I have tested it with
  a HTML/JavaScript application and the result is always that the TMX file
  is missing. I have left the code in in-case anyone notices a mistake I
  I have made.

## Disclaimer

I am not affiliated with MyMemory or Translated; I just made this as I saw there was no API to interact with these services in Flutter/Dart.