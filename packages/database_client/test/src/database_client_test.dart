// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:database_client/database_client.dart';
import 'package:test/test.dart';

void main() {
  group('DatabaseClient', () {
    test('can be instantiated', () {
      expect(DatabaseClient(), isNotNull);
    });
  });
}
