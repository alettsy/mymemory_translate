import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'keygen_test.dart';
import 'translate_test.dart';

@GenerateMocks([http.Client])
void main() {
  translateTests();
  keygenTests();
}
