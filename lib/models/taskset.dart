class TaskSet {
  final int id;
  final String title;

  const TaskSet({
    required this.id,
    required this.title,
  });

  factory TaskSet.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String title,
      } => 
        TaskSet (
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load TaskSet from Json'),
    };
  }
}



