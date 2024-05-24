class TaskSet {
  final int id;
  final int groupId;
  final String title;

  const TaskSet({
    required this.id,
    required this.groupId,
    required this.title,
  });

  factory TaskSet.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'group_id': int groupId,
        'name': String title,
      } => 
        TaskSet (
          id: id,
          groupId: groupId,
          title: title,
        ),
      _ => throw const FormatException('Failed to load TaskSet from Json'),
    };
  }
}



