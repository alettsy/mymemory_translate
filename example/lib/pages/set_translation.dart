import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mymemory_translate/mymemory_translate.dart';

class SetTranslation extends StatefulWidget {
  const SetTranslation({super.key});

  @override
  State<SetTranslation> createState() => _GetTranslationState();
}

class _GetTranslationState extends State<SetTranslation> {
  var loading = false;
  var statusText = 'Waiting';

  void setTranslation() async {
    setState(() {
      loading = true;
    });

    var translator = MyMemoryTranslate(http.Client());
    var result =
        await translator.setTranslation('Hello', 'Hallo', 'en-us', 'de');

    setState(() {
      loading = false;
      statusText = 'UUID of transaction: $result';
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
            const Text('Click to set "Hello" to "Hallo" for English to German'),
            ElevatedButton(
                onPressed: setTranslation, child: const Text('Set!')),
            const SizedBox(height: 20),
            Text(loading ? 'Loading...' : statusText),
          ],
        ),
      ),
    );
  }
}
