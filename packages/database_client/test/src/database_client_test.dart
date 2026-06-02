// Not required for test files
// ignore_for_file: prefer_const_constructors
import 'package:database_client/database_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/test.dart';

void main() {
  group('DatabaseClient', () {
    test('can be instantiated', () {
      expect(
        SupabaseDatabaseClient(SupabaseClient('http://localhost', 'dummy_key')),
        isNotNull,
      );
    });
  });
}
