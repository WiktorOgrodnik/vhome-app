class Task {
  final int id;
  final int taskSetId;
  final String title;
  final String content;
  final bool completed;
  // final DateTime completedTime;

  const Task({
    required this.id,
    required this.taskSetId,
    required this.title,
    required this.content,
    required this.completed,
    // required this.completedTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'vlist_id': int taskSetId,
        'title': String title,
        'content': String content,
        'completed': bool completed,
        // 'completedTime': DateTime completedTime,
      } => 
        Task (
          id: id,
          taskSetId: taskSetId,
          title: title,
          content: content,
          completed: completed,
          // completedTime: completedTime,
        ),
      _ => throw const FormatException('Failed to load Task from Json'),
    };
  }
}
