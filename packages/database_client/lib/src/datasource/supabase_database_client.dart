import 'package:supabase_flutter/supabase_flutter.dart';

import '../contracts/database_client.dart';

class SupabaseDatabaseClient implements DatabaseClient {
  final SupabaseClient client;

  SupabaseDatabaseClient(this.client);

  @override
  Future<void> createTodo(String title) async {
    // TODO: Implement
  }

  @override
  Future<void> deleteTodo(String id) async {
    // TODO: Implement
  }
}