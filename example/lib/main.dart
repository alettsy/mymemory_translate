import 'package:example/pages/generate_key.dart';
import 'package:example/pages/get_translation.dart';
import 'package:example/pages/importing.dart';
import 'package:example/pages/set_translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/get_translation': (context) => const GetTranslation(),
        '/set_translation': (context) => const SetTranslation(),
        '/keygen': (context) => const GenerateKey(),
        '/importing': (context) => const Importing(),
      },
      title: 'mymemory_translate examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('mymemory_translate examples'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed('/get_translation'),
              child: const Text('Get Translation'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/set_translation'),
              child: const Text('Set Translation'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/keygen'),
              child: const Text('Generate Key'),
            ),
            ElevatedButton(
              onPressed: () => Get.toNamed('/importing'),
              child: const Text('Import Translations'),
            ),
          ],
        ),
      ),
    );
  }
}
