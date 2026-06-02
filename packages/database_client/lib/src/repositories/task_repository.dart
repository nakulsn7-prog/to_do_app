import '../models/task.dart';

abstract class TaskRepository {
  Future<void> createTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String id);

  Stream<List<Task>> watchTasks();
}