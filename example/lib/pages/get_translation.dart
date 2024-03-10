import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mymemory_translate/mymemory_translate.dart';

class GetTranslation extends StatefulWidget {
  const GetTranslation({super.key});

  @override
  State<GetTranslation> createState() => _GetTranslationState();
}

class _GetTranslationState extends State<GetTranslation> {
  var loading = false;
  var translatedText = 'none';

  void translate() async {
    setState(() {
      loading = true;
    });

    var translator = MyMemoryTranslate(http.Client());
    var result = await translator.translate('Hello', 'en-us', 'de');

    setState(() {
      loading = false;
      translatedText = result.responseData.translatedText!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Get Translation'),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          )
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('Click to translate "Hello" from English to German'),
            ElevatedButton(
                onPressed: translate, child: const Text('Translate!')),
            const SizedBox(height: 20),
            Text(loading ? 'Loading...' : 'Translation: $translatedText'),
          ],
        ),
      ),
    );
  }
}
