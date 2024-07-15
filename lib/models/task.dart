class Task {
  final int id;
  final String title;
  final String content;
  final bool completed;
  // final DateTime? completedTime;

  const Task({
    required this.id,
    required this.title,
    required this.content,
    required this.completed,
    // required this.completedTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
        'content': String content,
        'completed': bool completed,
        //'completedTime': String completedTime,
      } => 
        Task (
          id: id,
          title: title,
          content: content,
          completed: completed,
          //completedTime: DateTime.tryParse(completedTime),
        ),
      _ => throw const FormatException('Failed to load Task from Json'),
    };
  }
}
