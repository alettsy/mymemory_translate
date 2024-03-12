import 'package:mymemory_translate/utils/errors.dart';
import 'package:test/test.dart';

void main() {
  test('EmptyStringError.toString()', () {
    expect(
        EmptyStringError('text').toString(), 'EmptyStringError(message: text)');
  });

  test('TranslationApiException.toString()', () {
    expect(MyMemoryException('text').toString(),
        'MyMemoryException(message: text)');
  });
}
