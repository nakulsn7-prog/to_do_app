import 'package:powersync/powersync.dart';

import '../models/task.dart';
import 'task_repository.dart';

class PowerSyncTaskRepository implements TaskRepository {
  final PowerSyncDatabase db;

  PowerSyncTaskRepository(this.db);

  @override
  Future<void> createTask(Task task) async {
    await db.execute(
      '''
      INSERT INTO tasks (
        id,
        title,
        completed
      )
      VALUES (?, ?, ?)
      ''',
      [
        task.id,
        task.title,
        task.completed,
      ],
    );
  }

  @override
  Future<void> updateTask(Task task) async {
    await db.execute(
      '''
      UPDATE tasks
      SET title = ?, completed = ?
      WHERE id = ?
      ''',
      [
        task.title,
        task.completed,
        task.id,
      ],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await db.execute(
      '''
      DELETE FROM tasks
      WHERE id = ?
      ''',
      [id],
    );
  }

  @override
  Stream<List<Task>> watchTasks() {
    return db.watch(
      '''
      SELECT *
      FROM tasks
      '''
    ).map(
      (rows) => rows
          .map((row) => Task.fromRow(row))
          .toList(),
    );
  }
}