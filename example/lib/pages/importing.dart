import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mymemory_translate/mymemory_translate.dart';

const _tmxContent = """
<?xml version="1.0" encoding="UTF-8"?>
<tmx version="1.4">
  <header
    creationtool="MyTranslationTool"
    creationtoolversion="1.0"
    segtype="sentence"
    o-tmf="tmx"
    adminlang="en-US"
    srclang="en-US"
    datatype="plaintext"
  />
  <body>
    <tu>
      <tuv xml:lang="en-US" creationdate="20240212T191726" lastusagedate="20240212T191726>
        <seg>Hello, how are you?</seg>
      </tuv>
      <tuv xml:lang="fr-FR" creationdate="20240212T191726" lastusagedate="20240212T191726>
        <seg>Bonjour, comment vas-tu?</seg>
      </tuv>
      <tuv xml:lang="es-ES" creationdate="20240212T191726" lastusagedate="20240212T191726>
        <seg>Hola, ¿cómo estás?</seg>
      </tuv>
    </tu>
    <tu>
      <tuv xml:lang="en-US" creationdate="20240212T191726" lastusagedate="20240212T191726>
        <seg>I am fine, thank you.</seg>
      </tuv>
      <tuv xml:lang="fr-FR" creationdate="20240212T191726" lastusagedate="20240212T191726>
        <seg>Je vais bien, merci.</seg>
      </tuv>
      <tuv xml:lang="es-ES" creationdate="20240212T191726" lastusagedate="20240212T191726>
        <seg>Estoy bien, gracias.</seg>
      </tuv>
    </tu>
    <tu>
        <prop type="x-Plural-Source-Group">src-plural-id</prop>
        <prop type="x-Plural-Rule">one</prop>
        <tuv xml:lang="en-US" creationdate="20240212T191726" lastusagedate="20240212T191726>
          <seg>{count} file</seg>
        </tuv>
        <tuv xml:lang="fr-FR" creationdate="20240212T191726" lastusagedate="20240212T191726>
          <prop type="x-Plural-Translation-Group">tr-plural-id-1</prop>
          <seg>{count] dossier</seg>
        </tuv>
        <tuv xml:lang="es-ES" creationdate="20240212T191726" lastusagedate="20240212T191726>
          <prop type="x-Plural-Translation-Group">tr-plural-id-2</prop>
          <seg>{count} archivo</seg>
        </tuv>
      </tu>
      <tu>
        <prop type="x-Plural-Source-Group">src-plural-id</prop>
        <prop type="x-Plural-Rule">other</prop>
        <tuv xml:lang="en-US" creationdate="20240212T191726" lastusagedate="20240212T191726>
          <seg>{count} files</seg>
        </tuv>
        <tuv xml:lang="fr-FR" creationdate="20240212T191726" lastusagedate="20240212T191726>
          <prop type="x-Plural-Translation-Group">tr-plural-id-1</prop>
          <seg>{count] dossiers</seg>
        </tuv>
        <tuv xml:lang="es-ES" creationdate="20240212T191726" lastusagedate="20240212T191726>
          <prop type="x-Plural-Translation-Group">tr-plural-id-2</prop>
          <seg>{count} archivos</seg>
        </tuv>
      </tu>
  </body>
</tmx>
""";

class Importing extends StatefulWidget {
  const Importing({super.key});

  @override
  State<Importing> createState() => _GetTranslationState();
}

class _GetTranslationState extends State<Importing> {
  var loadingImport = false;
  var importText = 'Waiting';
  var importUuid = '';

  var loadingImportStatus = false;
  var importStatusText = 'Waiting';

  late MyMemoryTranslate translator;

  @override
  void initState() {
    translator = MyMemoryTranslate(http.Client());
    super.initState();
  }

  void importFile() async {
    setState(() {
      loadingImport = true;
    });

    var exampleFile = File('example.tmx');
    exampleFile.writeAsString(_tmxContent);

    // var response = await translator.importTranslationMemoryFile(exampleFile);

    setState(() {
      loadingImport = false;
      importText = 'UUID of transaction: ';
      importUuid = '';
    });
  }

  void getImportStatus() async {
    setState(() {
      loadingImportStatus = true;
    });

    if (importUuid.isEmpty) {
      setState(() {
        loadingImportStatus = false;
        importStatusText = 'Import a file first';
      });
      return;
    }

    var response = await translator.getImportStatus(importUuid);
    var text = response.completed == 1 ? 'Yes' : 'No';

    setState(() {
      loadingImportStatus = false;
      importStatusText = 'Has completed: $text';
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
            const Text('Click to import an example file'),
            ElevatedButton(
                onPressed: importFile, child: const Text('Import File!')),
            const SizedBox(height: 20),
            Text(loadingImport ? 'Loading...' : importText),
            const SizedBox(height: 30),
            const Text('Click to get status of import'),
            ElevatedButton(
                onPressed: getImportStatus, child: const Text('Check Status!')),
            const SizedBox(height: 20),
            Text(loadingImportStatus ? 'Loading...' : importStatusText),
          ],
        ),
      ),
    );
  }
}
