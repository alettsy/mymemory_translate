import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymemory_translate/mymemory_translate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleTranslate(),
    );
  }
}

class ExampleTranslate extends StatefulWidget {
  const ExampleTranslate({super.key});

  @override
  State<ExampleTranslate> createState() => _ExampleTranslateState();
}

class _ExampleTranslateState extends State<ExampleTranslate> {
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
      translatedText = result.responseData.translatedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Translate'),
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
