abstract class DatabaseClient {
  Future<void> createTodo(String title);
  Future<void> deleteTodo(String id);
}