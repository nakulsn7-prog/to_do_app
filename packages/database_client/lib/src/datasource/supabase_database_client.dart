import 'package:supabase_flutter/supabase_flutter.dart';

import '../contracts/database_client.dart';
import '../models/task.dart';

class SupabaseDatabaseClient implements DatabaseClient {
  final SupabaseClient client;

  SupabaseDatabaseClient(this.client);

  @override
  Future<void> createTask(Task task) async {
    // TODO: Implement
  }

  @override
  Future<void> updateTask(Task task) async {
    // TODO: Implement
  }

  @override
  Future<void> deleteTask(String id) async {
    // TODO: Implement
  }

  @override
  Stream<List<Task>> watchTasks() {
    // TODO: Implement
    throw UnimplementedError();
  }
}
