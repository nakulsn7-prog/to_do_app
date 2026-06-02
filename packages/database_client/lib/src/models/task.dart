class Task {
  final String id;
  final String title;
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Task.fromRow(Map<String, dynamic> row) {
    return Task(
      id: row['id'] as String,
      title: row['title'] as String,
      completed: row['completed'] as bool,
    );
  }
}